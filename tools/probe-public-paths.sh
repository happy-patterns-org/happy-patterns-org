#!/bin/sh
# probe-public-paths.sh — the outside check for the paths in docs/public-paths.md
# (rule 5 of Operating Rules in AGENTS.md).
#
#   P1 site       each page returns HTTPS 200 with its expected <title>; the
#                 certificate has at least 14 days left; http:// redirects to https://.
#   P2 mail       MX for the domain exists and lists only Google hosts.
#   P3 mail auth  SPF matches; the DKIM and DMARC records match recorded sha256
#                 digests (digests, because the DMARC record carries an address
#                 and this repository is public).
#
# DNS is read over HTTPS from Google's public resolver, not from the zone's own
# provider. Read-only, no credentials. Needs curl, jq and openssl.
#
# Usage:  sh tools/probe-public-paths.sh
#         PROBE_INJECT_PATH=/no-such-page.html sh tools/probe-public-paths.sh
#             adds one page that must fail, to prove the alarm path end to end.
# Exit:   0 everything holds
#         1 a public path is down (P1 page not 200, P2 MX missing or not Google)
#         2 the probe itself is broken (missing tool, resolver unreachable)
#         3 drift only: a value changed but the path still serves
#
# When a value below changes on purpose (a new page, a title, the DMARC policy),
# update it here in the same pull request as that change.

set -u

DOMAIN=happy-patterns.com
DNS_API=https://dns.google/resolve
CERT_MIN_SECONDS=1209600 # 14 days

PAGES='/|Happy Patterns — Practical software for specialized workflows
/privacy.html|Privacy Policy — Happy Patterns
/support.html|Support — Happy Patterns
/products/scopecam.html|ScopeCam — Happy Patterns'

SPF_EXPECTED='v=spf1 include:_spf.google.com ~all'
DKIM_SHA256=f73b119e413112d49c9b6649a094b86b43137427aca1410f37b2707648f14478
DMARC_SHA256=46d315b4cc6d72f8eec1e612ee2c48f2dbea8668ee69cb8b74483b6b165b10f8

for t in curl jq openssl; do
	command -v "$t" >/dev/null 2>&1 || {
		printf 'ERROR missing tool: %s\n' "$t"
		exit 2
	}
done

# The injected path is appended to the site's origin, so it must be a plain path:
# a leading "/" and only URL-safe path characters (no "@", "|", spaces or "?").
if [ -n "${PROBE_INJECT_PATH:-}" ]; then
	case $PROBE_INJECT_PATH in
	/*) ;;
	*)
		printf 'ERROR PROBE_INJECT_PATH must start with /\n'
		exit 2
		;;
	esac
	case $PROBE_INJECT_PATH in
	*[!A-Za-z0-9._~/-]*)
		printf 'ERROR PROBE_INJECT_PATH may contain only letters, digits and . _ ~ / -\n'
		exit 2
		;;
	esac
fi

# Time budget: the job limit is 10 minutes and the report must still go out
# after a black-holed outage. Each request is capped at 10 s with one retry
# (about 23 s worst case); ten requests plus the 15 s TLS read stay under 5 min.
fetch() { curl -sS --connect-timeout 5 --max-time 10 --retry 1 --retry-delay 3 "$@" 2>/dev/null; }

with_timeout() {
	if command -v timeout >/dev/null 2>&1; then
		timeout "$@"
	else
		shift
		"$@"
	fi
}

down=0
broken=0
drift=0
ok() { printf 'ok    %s\n' "$*"; }
bad() { printf 'FAIL  %s\n' "$*"; }

tmp=$(mktemp -d "${TMPDIR:-/tmp}/probe.XXXXXX") || exit 2
trap 'rm -rf "$tmp"' EXIT

# dns NAME TYPE TYPENUM -> answer data of that type, sorted, one per line.
# Returns non-zero when the resolver is unreachable or the answer is not NOERROR.
dns() {
	json=$(fetch --retry-all-errors "$DNS_API?name=$1&type=$2") || return 1
	printf '%s' "$json" | jq -er --argjson t "$3" \
		'if .Status == 0 then ([.Answer[]? | select(.type == $t) | .data] | sort | join("\n")) else error("rcode") end' \
		2>/dev/null
}

digest() { openssl dgst -sha256 -r | cut -d' ' -f1; }

# --- P1: site ------------------------------------------------------------------
printf '%s\n' "$PAGES" >"$tmp/pages"
if [ -n "${PROBE_INJECT_PATH:-}" ]; then
	printf '%s|%s\n' "$PROBE_INJECT_PATH" "(injected: must fail)" >>"$tmp/pages"
fi
while IFS='|' read -r path title; do
	url="https://$DOMAIN$path"
	code=$(fetch -o "$tmp/body" -w '%{http_code}' "$url")
	[ -n "$code" ] || code=000
	if [ "$code" != 200 ]; then
		down=1
		bad "P1 $url returned $code"
	elif ! grep -qF "<title>$title</title>" "$tmp/body"; then
		drift=1
		bad "P1 $url is up but its title is not the expected one"
	else
		ok "P1 $url 200, title matches"
	fi
done <"$tmp/pages"

if with_timeout 15 openssl s_client -connect "$DOMAIN:443" -servername "$DOMAIN" </dev/null 2>/dev/null |
	openssl x509 -noout -checkend "$CERT_MIN_SECONDS" >/dev/null 2>&1; then
	ok "P1 certificate valid for at least 14 more days"
else
	drift=1
	bad "P1 certificate expires within 14 days or could not be read"
fi

r=$(fetch -o /dev/null -w '%{http_code} %{redirect_url}' "http://$DOMAIN/")
if [ "$r" = "301 https://$DOMAIN/" ]; then
	ok "P1 http:// redirects to https://"
else
	drift=1
	bad "P1 http:// does not redirect to https:// as expected (got: ${r:-nothing})"
fi

# --- P2: mail route ------------------------------------------------------------
if mx=$(dns "$DOMAIN" MX 15); then
	if [ -z "$mx" ]; then
		down=1
		bad "P2 no MX record"
	elif printf '%s\n' "$mx" | awk '{print $2}' | grep -qvE '(^|\.)google\.com\.$'; then
		down=1
		bad "P2 MX lists a host that is not Google's"
	else
		ok "P2 MX: $(printf '%s\n' "$mx" | wc -l | tr -d ' ') Google hosts"
	fi
else
	broken=1
	bad "P2 MX lookup failed (resolver unreachable or error answer)"
fi

# --- P3: mail authentication ---------------------------------------------------
if txt=$(dns "$DOMAIN" TXT 16); then
	spf=$(printf '%s\n' "$txt" | grep '^v=spf1' || true)
	if [ "$spf" = "$SPF_EXPECTED" ]; then
		ok "P3 SPF matches"
	else
		drift=1
		bad "P3 SPF differs from the recorded value"
	fi
else
	broken=1
	bad "P3 apex TXT lookup failed"
fi

if d=$(dns "google._domainkey.$DOMAIN" TXT 16); then
	if [ "$(printf '%s' "$d" | digest)" = "$DKIM_SHA256" ]; then
		ok "P3 DKIM record matches its recorded digest"
	else
		drift=1
		bad "P3 DKIM record changed (digest differs); if intended, update DKIM_SHA256"
	fi
else
	broken=1
	bad "P3 DKIM lookup failed"
fi

if d=$(dns "_dmarc.$DOMAIN" TXT 16); then
	policy=$(printf '%s' "$d" | sed -n 's/.*[; ]p=\([a-z]*\).*/\1/p')
	if [ "$(printf '%s' "$d" | digest)" = "$DMARC_SHA256" ]; then
		ok "P3 DMARC record matches its recorded digest (p=${policy:-?})"
	else
		drift=1
		bad "P3 DMARC record changed (p=${policy:-?}; digest differs); if intended, update DMARC_SHA256"
	fi
else
	broken=1
	bad "P3 DMARC lookup failed"
fi

[ "$down" -ne 0 ] && exit 1
[ "$broken" -ne 0 ] && exit 2
[ "$drift" -ne 0 ] && exit 3
exit 0
