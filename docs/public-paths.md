# Public Paths

These are the business-critical public paths of Happy Patterns, with the outside check for each one.

A path belongs on this list when someone outside Happy Patterns relies on it to reach the business, such as a customer, an app reviewer or a receiving mail server. Each path needs a scheduled check that runs from outside what it checks. That check raises an alarm in two cases: the path fails, or the check itself goes silent.

Public data only: no credentials, account identifiers or addresses.

## The list

| # | Path | Served by | Who relies on it | Outside check | Silence alarm |
|---|---|---|---|---|---|
| P1 | Website: `https://happy-patterns.com/`, `/privacy.html`, `/support.html`, `/products/scopecam.html` | GitHub Pages, built from the site repository's `main` branch; custom domain set by `CNAME`; DNS at Cloudflare | Customers, plus anyone sent to the privacy or support page | None | None |
| P2 | Mail to the support and privacy addresses published on `/support.html` | Google Workspace (MX for `happy-patterns.com`) | Customers asking for support or making a privacy request | None | None |
| P3 | Authentication for outgoing mail from `happy-patterns.com` (SPF, DKIM, DMARC) | DNS records at Cloudflare; signing by Google Workspace | Receiving servers deciding whether mail from the domain is genuine | None. DMARC aggregate reports are the planned evidence (issue #7) | None |

The site's pull-request gate (`site-gate`) checks the source before a merge. It never looks at the live site, so it is not an outside check.

Readback on 2026-11-23T18:00:47Z: the four P1 pages each returned HTTP 200 over HTTPS with a valid certificate, and `http://` redirected to `https://` with a 301. That is a single read, not a check. The mail records behind P2 and P3 were last read on 2026-11-15 (`docs/status.md`).

## Not on the list, and why

- **Logins and forms:** Happy Patterns offers no public login and no form. The site is static and runs no JavaScript.
- **Backups:** Happy Patterns runs no scheduled backup job today. If one is added, it joins this list with a check that a new copy actually landed.
- **ScopeCam distribution:** this repository does not record whether an app-store listing is live. Once one is, its listing page joins this list.

## Proposed checks (not built)

What each probe asserts:

- **P1:** every page returns HTTP 200 over HTTPS on the custom domain and shows its expected `<title>`; the certificate is valid for `happy-patterns.com` with at least 14 days left; `http://` redirects to `https://`.
- **P2:** MX for `happy-patterns.com` lists the Google hosts. The probe does not test delivery to the published addresses, because that needs a sending path and the right to read a mailbox. That is a credential decision and is left out here.
- **P3:** the SPF, `google._domainkey` and `_dmarc` records exist and match the values recorded in `docs/status.md`.

Where the probes run. A scheduled GitHub Actions workflow on its own does not count as outside P1, for two reasons. First, it runs on GitHub, the same platform that serves Pages. Second, GitHub stops scheduled workflows in a public repository after 60 days with no activity, which is exactly the silent failure this list guards against. So the probe reports to a heartbeat service outside GitHub after every run, whether the run succeeded or failed. That service raises an alarm when a run fails and when the reports stop.

The parent runs no shared prober (asked 2026-11-23). The recommended heartbeat service sits in the owner's own account. Adding a check there is a provider change, and the check's ping address is a credential, so the choice is the owner's. It is tracked in issue #15, which also gives the alternative.

Who is told, under the owner's standing alert rule (issue #12, Standing rules):

- **P1 or P2 fails:** a public-facing service is down, so the owner is told. The alert says what failed, what an agent tried, and the one thing needed from the owner.
- **P3 drifts, or the check goes silent:** an agent hears first, through an issue. The owner hears only if no agent can restore it.

Once the runner is chosen: an agent builds the probes, records where they run and fills in the two check columns above. As a readback, the agent shows the alarm firing once on a deliberate failure (a probe of a page that does not exist) and once on a missed heartbeat.

---

Last updated: 2026-11-23
