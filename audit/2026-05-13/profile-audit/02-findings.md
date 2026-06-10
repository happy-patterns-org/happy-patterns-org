# Findings

Findings are audit observations only. No remediation was performed.

## F-001 - Root README conflicts with actual root git state

`README.md` says the Happy Patterns workspace is "Not a git repository" and that each subdirectory is its own repo or purpose (`README.md:1-4`). Current local evidence shows the root is a git repository on `main` at `0c58d5ba2d591ad19805e3f6b04a1c50e786e636`, tracking `origin/main`.

Impact: root-vs-child repository boundaries are ambiguous for future agents. The `.gitignore` intentionally ignores child repos and private lanes (`.gitignore:25-29`), but the README statement overclaims the root shape.

Classification: root boundary ambiguity.

## F-002 - Root `AGENTS.md` and `CLAUDE.md` are not text-identical on project entrypoint guidance

`AGENTS.md` repeats `AGENTS.md` in the project-context paragraph (`AGENTS.md:131-136`), while `CLAUDE.md` correctly says projects may have `CLAUDE.md` and/or `AGENTS.md`. The files are otherwise aligned in purpose, but this drift is in an agent-facing authority section.

Impact: Codex-oriented agents may miss that nested `CLAUDE.md` files are intended project authority surfaces.

Classification: agent-facing authority drift.

## F-003 - Ignored root Claude settings grant provider and records-write capability outside tracked root contracts

Root `.claude/settings.local.json` is ignored by root git (`.gitignore:20-23`) but allows provider CLIs and a records-directed `rsync` command (`.claude/settings.local.json:1-10`). Root contracts say records are sensitive local custody material and not routine development context (`CONTRIBUTING.md:11-12`, `CONTRIBUTING.md:21`), while root `.gitignore` hides both `.claude/` and `records/`.

Impact: a local agent authority surface can touch provider tools and write into records, but this surface is not disclosed in tracked root docs as an active action surface.

Classification: undisclosed local agent/runtime surface.

## F-004 - Root `.envrc` points to an external contract outside Happy Patterns-local authority

Root `.envrc` references a secrets contract outside the Happy Patterns tree (`.envrc:3`) and loads a host-secret helper before exporting GitHub token variables (`.envrc:5-10`). Happy Patterns root authority says not to traverse upward/outside this directory during normal operation (`AGENTS.md:15-17`, `AGENTS.md:95-102`).

Impact: local environment behavior depends on an external contract that is not Happy Patterns-local authority. This is action-surface leakage, even if the actual token values remain in the secrets authority.

Classification: prompt/SOP and environment authority leakage.

## F-005 - Root `.claude/relocation-hold` contains publication and DNS planning material that is not classified as current or historical authority

Root `.claude/relocation-hold/happy-patterns-org.github.io-2026-05-01/` is ignored local agent state but contains a DNS import surface and a rough public-site plan. Targeted grep found DNS/provider and GitHub Pages publication content in `dns-import.txt` and `rough-plan.md`. `CONTRIBUTING.md` says DNS imports, rough plans, and temporary notes should be classified before becoming public site history (`CONTRIBUTING.md:60-64`).

Impact: publication-adjacent history exists in ignored local state, with no tracked classification saying whether it is rough, superseded, evidence, or current source.

Classification: publication surface ambiguity.

## F-006 - Records repo is local-only by contract but has sensitive tracked classes and untracked material

`records/CLAUDE.md` says the records repository has no remote and must never be pushed (`records/CLAUDE.md:9-18`). It also says the repo holds legal filings, tax strategy, formation documentation, session notes, invoices, and expense records (`records/CLAUDE.md:3`, `records/CLAUDE.md:20-28`). Local git status showed `?? budget-triage/`.

Impact: sensitive custody material is intentionally in a nested local git repo, but untracked material is present and root git hides the entire lane. That is acceptable only if treated as local custody, not development context; future agents need the boundary to remain explicit.

Classification: records-sensitive placement and status ambiguity.

## F-007 - ScopeCam worktree has a pre-existing toolchain modification that contradicts current status text

ScopeCam local status showed a modified `gradle/libs.versions.toml`. The diff changes `androidGradlePlugin` from `9.2.0` to `9.3.0-alpha04`. ScopeCam status still states current build pins include AGP `9.2.0` (`apps/scopecam/docs/STATUS.md:25`) and release-critical work should carry AGP `9.2.0` / Kotlin `2.3.21` through device validation (`apps/scopecam/docs/STATUS.md:153`).

Impact: local working-tree truth and canonical status disagree. Because this audit is read-only, the change was not evaluated or reverted.

Classification: nested app dirty-state/status drift.

## F-008 - ScopeCam required-check language depends on provider state that this audit did not verify

ScopeCam `AGENTS.md` says both `development` and `main` are protected by rulesets requiring a single `gate` status check (`apps/scopecam/AGENTS.md:42-47`, `:86-100`). `docs/STATUS.md` records provider protection as observed on 2026-04-27 (`apps/scopecam/docs/STATUS.md:98`). Under this audit's stop rules, no GitHub ruleset or branch-protection provider check was performed.

Impact: current required/blocking status cannot be reasserted from this audit alone. The local source can be classified as source-defined plus previously observed, not current provider-verified.

Classification: CI required-check evidence staleness.

## F-009 - ScopeCam local Claude settings are broad, stale, and provider/device capable

Tracked ScopeCam Claude settings allow `gh`, `adb`, selected `op`, web search, and MCP provider/search surfaces (`apps/scopecam/.claude/settings.json:3-29`). Ignored local settings are much broader, including Infisical, Tailscale, ADB network/device operations, broad reads under `/Users/verlyn13`, `op item`, and cleanup commands (`apps/scopecam/.claude/settings.local.json:16-18`, `:22-35`, `:59-71`, `:108-132`).

Impact: local agent capability is materially broader than tracked project authority. This may be intentional for a developer workstation, but it should be classified as local convenience and not project policy.

Classification: undisclosed local agent/runtime surface.

## F-010 - ScopeCam release, app distribution, Test Lab, and OIDC workflows are provider-active if dispatched but not blocking by source alone

ScopeCam source defines release and ops workflows that can reach Infisical, Firebase, GCP WIF, Test Lab, App Distribution, and Crashlytics if triggered (`apps/scopecam/.github/workflows/release.yml:13-16`, `:90-123`; `ops-app-distribution.yml:1-7`, `ops-firebase-test-lab.yml:1-6`, `ops-oidc-debug.yml:20-21`). `release.yml` explicitly says its gate is not a required status check (`apps/scopecam/.github/workflows/release.yml:133-135`), and `ops-firebase-test-lab.yml` says it is not a gating workflow.

Impact: these workflows are live/provider-capable surfaces in source, but this audit should not classify them as blocking gates without provider evidence.

Classification: runtime/provider workflow classification risk.

## F-011 - ScopeCam `.envrc` imports external host-secret language into a Happy Patterns app surface

ScopeCam `.envrc` is a live local environment action surface. It loads Infisical app config and 1Password Android signing material (`apps/scopecam/.envrc:1-28`, `:40-47`, `:54-84`) and also points to an external contract path and host-secret terminology (`apps/scopecam/.envrc:17-20`, `:55-58`).

Impact: local secrets behavior may be correct for this workstation, but the authority wording is not self-contained inside Happy Patterns and should not be generalized to the subsidiary root.

Classification: environment authority leakage.

## F-012 - Website deployment is source-claimed but not locally proved as current provider state

The website repo says it hosts on GitHub Pages from `main` with custom domain `happy-patterns.com` (`apps/happy-patterns-org.github.io/AGENTS.md:5-13`, `README.md:26-28`), and `CNAME` contains the domain (`apps/happy-patterns-org.github.io/CNAME:1`). No `.github/workflows/*` files were observed in the website repo, and no Pages provider state was checked.

Impact: deployment should be classified as source-defined/trace-blocked in this audit, not current provider-verified.

Classification: public-site/deploy evidence gap.

## F-013 - Website local settings allow direct git commit actions while the branch is `main`

Website `.claude/settings.json` allowlists `git add`, `git commit`, branch, checkout, and switch operations (`apps/happy-patterns-org.github.io/.claude/settings.json:7-16`). The local website repo is on `main`. Root authority forbids pushing to `main` or production branches without an approved PR (`AGENTS.md:97`), and website source says pushing to `main` deploys automatically (`apps/happy-patterns-org.github.io/README.md:26-28`).

Impact: commit permission alone is not a deploy, but because website publication is tied to `main`, local agent settings do not encode the root production-branch caution.

Classification: public-site action-surface boundary risk.

## F-014 - ScopeCam local hooks can write/stage changes and installed `.git/hooks` wrappers are active runtime surfaces

ScopeCam `lefthook.yml` says pre-commit runs `ktlintFormat` and stages fixed Kotlin files (`apps/scopecam/lefthook.yml:17-25`). Installed `.git/hooks/pre-commit`, `pre-push`, `commit-msg`, and `prepare-commit-msg` wrappers call lefthook (`apps/scopecam/.git/hooks/pre-commit:11-71`, `apps/scopecam/.git/hooks/pre-push:11-71`). `lefthook.yml` also states CI remains authoritative, with hooks as fast guardrails (`apps/scopecam/lefthook.yml:7-15`).

Impact: hooks are correctly framed as local guardrails in ScopeCam, but they are write-capable local automation and should not be treated as policy enforcement outside that project.

Classification: runtime/action surface.
