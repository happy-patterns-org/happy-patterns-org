# Status Notes

Dated, append-only notes on operational state that is not visible in code. Newest first. Public data only: no credentials, account identifiers, or financial details.

## 2026-11-14: Mail DNS cleanup for happy-patterns.com

A retired mail relay left stale records in the zone. The apex SPF record included a name that no longer resolved, which receivers evaluate as a permanent error. Mail itself is delivered through Google and was not affected.

Changes made by the owner in the DNS dashboard. No agent changed the DNS provider:

1. Apex SPF TXT changed from `v=spf1 include:_spf.google.com include:spf.postal.jefahnierocks.com ~all` to `v=spf1 include:_spf.google.com ~all`.
2. `psrp` CNAME (pointing at the retired relay) deleted.
3. `postal-hficbn._domainkey` TXT (the retired relay's DKIM key) deleted.

Left untouched: MX (five Google hosts), DMARC, site verification, GitHub Pages records, and the two Postmark records.

Readback, public resolver 1.1.1.1, taken independently by the owner and by the agent session (agent readback at 2026-11-15T00:21:23Z), plus the parent orchestrator's own readback at 2026-11-15T00:20:57Z, all in agreement:

- TXT `happy-patterns.com`: the site-verification record and `v=spf1 include:_spf.google.com ~all`.
- `psrp.happy-patterns.com`: no answer.
- `postal-hficbn._domainkey.happy-patterns.com`: no answer.
- MX `happy-patterns.com`: the five Google hosts, unchanged.
- `happy-patterns.co`: only SOA and NS; nothing to clean.

Repository check: no file in this repository referenced the retired relay.
