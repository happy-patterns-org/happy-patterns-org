# Happy Patterns LLC — Workspace

Workstation workspace for Happy Patterns LLC. The root is a minimal git shell repo (governance, workspace docs, and audit packets only); child repos under `apps/` and `packages/` are their own git repositories, kept out of this shell by `.gitignore`, and `records/` is a local-only lane that is never pushed.

## Layout

| Path | Purpose |
|---|---|
| `apps/` | Product applications — each subdir is its own git repo |
| `packages/` | Shared libraries — each subdir is its own git repo |
| `audit/` | Date-stamped read-only audit packets (findings only; remediation is decided separately) |
| `docs/governance/` | Happy Patterns-authored operating standards and restatements |
| `records/` | Local-only legal/tax/formation records (never pushed) |
| `CLAUDE.md` | Entity governance (authoritative for agent sessions here) |
| `CONTRIBUTING.md` | Organization-level contribution workflow |
| `.subsidiary.yaml` | Public Happy Patterns metadata only |
| `.gitignore` | Keeps child repos, records, local tools, and secrets outside this shell repo |
| `.envrc` | Loads Happy Patterns GitHub PAT from 1Password |

## GitHub

Organization: [happy-patterns-org](https://github.com/happy-patterns-org)

## Contact

jeffrey@happy-patterns.com
