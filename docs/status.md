# Status Notes

Dated, append-only notes on operational state that is not visible in code. Newest first. Public data only: no credentials, account identifiers, or financial details.

## 2026-11-15: Mail authentication finding for happy-patterns.com

A message sent from the domain on 2026-11-14 carried Google's default DKIM signature, not one for happy-patterns.com. The zone had no `google._domainkey` record then, so DMARC passed on SPF alone.

Recorded policy: DMARC is `p=none`, with aggregate reports enabled, 100% pct and relaxed alignment (public resolver 1.1.1.1, 2026-11-15). It stays `p=none` for now; tightening is proposed only after DKIM signing for the domain has been in place and aggregate reports are clean.

Owner batch for Google DKIM signing and for retiring the Postmark records (if unused) is tracked in issue #7. Repository check: nothing in this repository refers to Postmark.

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
