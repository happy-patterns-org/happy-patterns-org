#!/bin/sh
# check-staged-guard.sh — a mechanical guard beyond the ignore rules.
#
# Fails when a commit, or the tracked tree, contains a path that must never be
# published from the shell root: the quarantined audit freeze, git rerere caches,
# environment files, private keys and credential stores. It also trips on a bulk
# add (very many staged files), which is how an ignore-rule gap becomes a leak.
#
# It reads PATH NAMES only (git index / git ls-files). It never opens a file and
# never prints file contents. Offending paths are printed by name so they can be
# unstaged; names under quarantine are reported by pattern class, not listed.
#
# Dependency-free POSIX sh; needs only git.
#
# Usage:  sh tools/check-staged-guard.sh --staged    (pre-commit: index vs HEAD)
#         sh tools/check-staged-guard.sh --tracked   (CI: every tracked path)
# Env:    HP_BULK_LIMIT=500  staged-file count that trips the bulk-add check
#         HP_ALLOW_BULK=1    owner-approved bulk change; skips only the count check
# Exit:   0 = clean   1 = violation   2 = usage error

set -u

MODE=${1:-}
LIMIT=${HP_BULK_LIMIT:-500}

case "$MODE" in
--staged) LIST='git diff --cached --name-only --diff-filter=ACMR -z' ;;
--tracked) LIST='git ls-files -z' ;;
*)
	echo "usage: $0 --staged | --tracked" >&2
	exit 2
	;;
esac

tmp=$(mktemp "${TMPDIR:-/tmp}/guard.XXXXXX") || exit 2
trap 'rm -f "$tmp"' EXIT INT TERM
# NUL-separated names into a newline list; a name containing a newline is itself a
# violation worth failing on, so tr is acceptable here.
$LIST | tr '\0' '\n' >"$tmp" || {
	echo "FAIL  could not list paths with git" >&2
	exit 2
}

bad=0
count=$(grep -c . "$tmp")

classify() {
	# Print a class label for a forbidden path, or nothing.
	case "$1" in
	audit/*/evidence/freeze/*) echo "quarantined audit freeze" ;;
	*/rr-cache/* | rr-cache/*) echo "git rerere cache" ;;
	.env.example | .env.sample | .env.template | */.env.example | */.env.sample | */.env.template) ;;
	.env | .env.* | */.env | */.env.*) echo "environment file" ;;
	*.pem | *.key | *.p12 | *.pfx | *.jks) echo "key material" ;;
	id_rsa | id_rsa.* | id_ed25519 | id_ed25519.* | */id_rsa | */id_rsa.* | */id_ed25519 | */id_ed25519.*)
		echo "ssh private key" ;;
	.npmrc | .netrc | .git-credentials | */.npmrc | */.netrc | */.git-credentials | */.docker/config.json)
		echo "credential store" ;;
	*/credentials/*.json | credentials/*.json | */auth.json | auth.json) echo "credential file" ;;
	esac
}

while IFS= read -r p; do
	[ -n "$p" ] || continue
	cls=$(classify "$p")
	if [ -n "$cls" ]; then
		bad=1
		if [ "$cls" = "quarantined audit freeze" ]; then
			printf 'FAIL  a path under the quarantined audit freeze is in the change (%s); name withheld\n' "$cls" >&2
		else
			printf 'FAIL  %s: %s\n' "$cls" "$p" >&2
		fi
	fi
done <"$tmp"

if [ "$MODE" = "--staged" ] && [ "${HP_ALLOW_BULK:-0}" != "1" ] && [ "$count" -gt "$LIMIT" ]; then
	bad=1
	printf 'FAIL  bulk add: %s files staged (limit %s). Stage by explicit path; never git add -A, git add ., or git commit -a at the shell root. Owner-approved bulk change: HP_ALLOW_BULK=1.\n' "$count" "$LIMIT" >&2
fi

if [ "$bad" -eq 0 ]; then
	printf 'ok    staged-guard (%s): %s paths checked, none forbidden\n' "$MODE" "$count"
	exit 0
fi
exit 1
