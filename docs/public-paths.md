# Public Paths

These are the business-critical public paths of Happy Patterns, with the outside check for each one.

A path belongs on this list when someone outside Happy Patterns relies on it to reach the business, such as a customer, an app reviewer or a receiving mail server. Each path needs a scheduled check that runs from outside what it checks. That check raises an alarm in two cases: the path fails, or the check itself goes silent.

Public data only: no credentials, account identifiers or addresses.

## The list

| # | Path | Served by | Who relies on it | Outside check | Silence alarm |
|---|---|---|---|---|---|
| P1 | Website: `https://happy-patterns.com/`, `/privacy.html`, `/support.html`, `/products/scopecam.html` | GitHub Pages, built from the site repository's `main` branch; custom domain set by `CNAME`; DNS at Cloudflare | Customers, plus anyone sent to the privacy or support page | None | None |
| P2 | Mail to the addresses published on `/support.html` | Google Workspace (MX for `happy-patterns.com`) | Customers asking for support or making a privacy request | None | None |
| P3 | Authentication for outgoing mail from `happy-patterns.com` (SPF, DKIM, DMARC) | DNS records at Cloudflare; signing by Google Workspace | Receiving servers deciding whether mail from the domain is genuine | None. DMARC aggregate reports are the planned evidence (issue #7) | None |

The site's pull-request gate (`site-gate`) checks the source before a merge. It never looks at the live site, so it is not an outside check.

Readback on 2026-11-23T18:00:47Z: the four P1 pages each returned HTTP 200 over HTTPS with a valid certificate, and `http://` redirected to `https://` with a 301. That is a single read, not a check. The mail records behind P2 and P3 were last read on 2026-11-15 (`docs/status.md`).

## Not on the list, and why

- **Logins and forms:** Happy Patterns offers no public login and no form. The site is static and runs no JavaScript.
- **Backups:** Happy Patterns runs no scheduled backup job today. If one is added, it joins this list with a check that a new copy actually landed.
- **ScopeCam distribution:** this repository does not record whether an app-store listing is live. Once one is, its listing page joins this list.

## Checks

The probes are built in PR #17 (`tools/probe-public-paths.sh`, run hourly by `.github/workflows/public-paths.yml`). The two check columns above stay "None" until #17 is merged, the owner has set the two report addresses, and an agent has shown the alarm firing.

What each probe asserts:

- **P1:** every page returns HTTP 200 over HTTPS on the custom domain and shows its expected `<title>`; the certificate is valid for `happy-patterns.com` with at least 14 days left; `http://` redirects to `https://`. `www.happy-patterns.com` only redirects to the apex (301, read 2026-11-23); nothing links to it, so it is not a separate path.
- **P2:** MX for `happy-patterns.com` exists and lists only Google hosts. The probe does not test delivery to the published addresses, because that needs a sending path and the right to read a mailbox. That is a credential decision and is left out here.
- **P3:** SPF equals its recorded value. The DKIM and DMARC records match sha256 digests of the full live records taken on 2026-11-23 and kept in the probe script. Digests, because the DMARC record contains an address and this repository is public. `docs/status.md` records the properties of these records, not their full values.

Where the probes run. A scheduled GitHub Actions workflow on its own does not count as outside P1, for two reasons. First, it runs on GitHub, the same platform that serves Pages. Second, GitHub stops scheduled workflows in a public repository after 60 days with no activity, which is exactly the silent failure this list guards against. So the probe reports to a heartbeat service outside GitHub after every run, success or failure. That service raises an alarm on a failure report and when the reports stop. The parent runs no shared prober (issue #15). The service sits in the owner's own account, and the owner chose it in issue #15.

Who is told. This follows the owner's alert rule: rule 2 of Operating Rules in `AGENTS.md` once PR #16 is merged, and until then issue #12, Standing rules.

- **P1 or P2 fails:** a public-facing service is down. The probe sends a failure report, and the heartbeat service alerts the owner. An agent issue records what failed and what the agent tried.
- **Drift (P3, a page title, the certificate window, the redirect):** an agent hears through an issue labelled `needs-agent-action`. The owner is not alerted.
- **The probe breaks:** an agent hears through an issue. If it stays broken past the service's grace period, the silence alarm reaches the owner.
- **The check goes silent for any other reason** (GitHub down, or the schedule stopped despite the keepalive): the silence alarm reaches the owner directly. No path yet carries the heartbeat service's alarm into an agent issue. Until one exists, silence reaches the owner first, because nothing inside GitHub can observe that its own runs have stopped.

Unclaimed alarms. No escalation floor is adopted for an agent issue that nobody claims. Both routes below that would reach the owner go through the heartbeat check. Until that check exists and its addresses are set, an unclaimed issue reaches no one beyond itself.

- **An unclaimed drift issue** stays open, and later runs do not add to it. A certificate that keeps shrinking turns into a page failure once it expires. Once the heartbeat check exists and its addresses are set, that failure reaches the owner as a P1 failure. Drift in P3, a page title or the redirect reaches no one beyond the open issue.
- **An unclaimed probe-broken issue:** once the heartbeat check exists and its addresses are set, the silence alarm reaches the owner after the grace period passes.

Routing the silence alarm to an agent first is issue #18.

Readback, once the addresses are set: an agent shows the alarm firing once on a deliberate failure (a probe of a page that does not exist) and once on a missed report, then fills in the two check columns above.

---

Last updated: 2026-11-24
