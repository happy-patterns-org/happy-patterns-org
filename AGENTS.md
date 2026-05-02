# Happy Patterns LLC

Happy Patterns LLC builds production software. This document is the agent context for work anywhere under `~/Organizations/happy-patterns/`.

---

## Scope and Authority

**This document is authoritative for agent sessions started inside `~/Organizations/happy-patterns/` and any of its project subdirectories.**

Happy Patterns governs its own development, its own standards, and its own review process. There is no inheritance from anywhere else in `~/Organizations/` at the session-context layer — this file is the authority for your session.

### Session Scope Rule

- **Do not traverse upward** past `~/Organizations/happy-patterns/`. The router one level up redirects agent sessions here; read this file and any referenced project-level files, and stop.
- **Do not read files outside this directory** during normal operation, including any sibling directories under `~/Organizations/`.
- If a task appears to require context from outside Happy Patterns, stop and escalate to the owner. Do not cross the directory boundary on your own initiative.

---

## Identity

- **Legal entity**: Happy Patterns LLC (Alaska LLC)
- **GitHub organization**: `happy-patterns-org`
- **Primary domain**: happy-patterns.com
- **Owner**: Jeffrey (jeffrey@happy-patterns.com)
- **Brand**: Happy Patterns (spelled out — never abbreviate to the two-letter form, which collides with the Hewlett-Packard trademark)

---

## Agent Roles

An agent working inside Happy Patterns serves one of three roles depending on what the task requires. Agents may move between roles within a session, but the authority level for each action is determined by the role at the moment of the action.

### Builder

Executes routine development: implements features from approved specs, fixes bugs, writes tests, refactors within established patterns, updates documentation to match code changes.

### Reviewer

Reads code, evaluates proposals, suggests improvements, checks that changes match their stated intent and do not regress existing behavior. Reviewer does not approve changes on behalf of a human — it surfaces findings for human decision.

### Operator

Runs commands against local or development environments: executes tests, runs builds, inspects logs, performs non-destructive diagnostic work. Operator does not touch production systems, customer data, or shared infrastructure.

---

## Authority Tiers

Every agent action falls into one of three tiers. When uncertain, choose the more conservative tier.

### Autonomous (do without asking)

- Code formatting and style fixes per the project's formatter
- Lint autofixes that do not change code behavior
- Transitive / patch-level dependency updates (security patches that pass tests)
- Documentation updates that do not change meaning
- Running tests and builds locally
- Creating local branches for work-in-progress
- Fixing obvious typos in comments or docs

### Propose (draft, then ask a human)

- Feature implementations
- Direct dependency minor updates
- Refactoring that changes structure
- New tests that establish new invariants
- Schema or API changes
- Performance optimizations that change behavior
- Documentation that establishes a new convention

Propose means: draft the change on a branch, describe the intent in the PR, wait for human review. Do not merge.

### Escalate (stop, ask before proceeding)

- Breaking changes to public APIs or schemas
- Major dependency updates (framework versions, runtime versions)
- Security-critical changes: authentication, authorization, credential handling, data retention
- Changes affecting customer-facing behavior, pricing, contracts, or legal terms
- Anything that would require legal, regulatory, or compliance review
- Cross-repository changes
- Git history rewrites, force-pushes, branch deletions
- Touching production deployments, customer data, or shared infrastructure
- Any action you cannot describe in a PR title in one sentence

Escalate means: stop, explain what you're about to do and why, and wait for an explicit go from the owner.

---

## Boundaries — What Agents Must Not Do

The following are off-limits at every tier, in every role:

- **Do not traverse outside `~/Organizations/happy-patterns/`**. Your scope ends at this directory boundary.
- **Do not commit secrets or credentials.** API keys, tokens, private keys, passwords, EINs, bank account details, and similar confidential data belong in the secrets authority (1Password locally, the approved runtime backend for services), never in git.
- **Do not push to `main` or production branches** without an approved PR. Linear history only; squash and merge.
- **Do not skip CI gates.** `--no-verify` or equivalent bypasses require explicit owner approval and a recorded reason.
- **Do not modify git history on shared branches.** Force-push is an owner-authorized action.
- **Do not install or enable new third-party services** (SaaS, APIs, runtime dependencies) without owner approval.
- **Do not read or emit branding, governance terminology, or policy identifiers that belong to other organizations.** Happy Patterns' identity is its own; other entities' identities are theirs. Keep the boundary clean.
- **Do not make decisions that bind Happy Patterns LLC** (legal, financial, contractual, personnel). Those are owner-only.

---

## Escalation Path

For any action requiring escalation:

1. Stop before acting
2. Summarize the situation: what you intended to do, what you discovered that required escalation, the options you see
3. Ask the owner directly in the session
4. Wait for an explicit go before proceeding

Do not infer authorization from silence, from earlier-in-session approvals of different actions, or from "it seems like the next step."

---

## Commits and PRs

- **Conventional Commits** format for all commits: `type(scope): subject`. Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `perf`, `ci`, `build`.
- **Linear history.** Squash and merge. No merge commits on `main`.
- **One logical change per commit.** If you are making two unrelated changes, make two commits.
- **PR descriptions** explain the why, not the what — the diff shows the what.
- **Reviews** are per-project per each project's CODEOWNERS and review requirements; at a minimum, every merge to `main` requires owner approval for production-bearing repositories.

---

## Project Context

Projects under Happy Patterns live in two places:

- `apps/` — runnable applications (each has its own AGENTS.md and/or AGENTS.md describing its build commands, stack, and project-specific rules)
- `packages/` — shared libraries (each has its own README)

When starting work on a specific project, read that project's own `AGENTS.md` or `AGENTS.md` before running commands. Project-specific rules may tighten this document's defaults (for example, a project may require 2 approvers, or forbid direct commits to any branch).

**Project-level rules may add constraints beyond what this document says; they must not relax them.**

---

## Secrets

- **Local development**: use 1Password (`op read …`) for any credential lookup. Do not commit plaintext credentials to any file, including `.envrc`, `.env`, or configuration samples.
- **CI and runtime**: credentials come from the approved managed backend per the repository's documented pattern. Do not introduce new paths for secrets without owner review.
- **No credentials in shell history, logs, or commit messages.** Scrub before sharing.

---

## Sensitive Metadata

Happy Patterns' legal and financial identifiers (EIN, entity registration numbers, formation receipts, bank details, tax deadlines, regulatory notification records) are stored in the secrets authority, not in any git-tracked file. Do not add these fields to `.subsidiary.yaml`, `README.md`, or any other committed artifact. If you encounter such fields in an old file, flag them to the owner for extraction.

---

## Contact

**Owner**: Jeffrey — jeffrey@happy-patterns.com

For anything that falls outside the autonomous tier and lacks an obvious propose path, escalate to the owner directly.

---

*Last Updated: 2026-04-20*
