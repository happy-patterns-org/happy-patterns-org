# Contributing to Happy Patterns

Happy Patterns builds production software for focused business, education, and applied tooling needs. This file is the organization-level contribution contract for work under `~/Organizations/happy-patterns/`.

Project-specific contracts still control their own repositories. When a project has its own `CLAUDE.md`, `AGENTS.md`, README, scripts, or review rules, read those before changing files in that project.

## Working Rules

- Start from the local Happy Patterns contracts: `CLAUDE.md`, `AGENTS.md`, and `README.md`.
- Stay inside the Happy Patterns workspace unless the owner gives explicit direction for a cross-location task.
- Do not inspect `records/` unless the owner explicitly asks. It is local-only custody material, not development context.
- Do not commit secrets, credentials, legal identifiers, tax records, bank details, formation records, recovery material, or private customer data.
- Keep Happy Patterns language plain and specific. Do not import another organization's branding, role names, policy labels, or governance vocabulary.
- Keep changes scoped to the task. Separate unrelated work into separate commits or separate branches.

## Workspace Layout

- `apps/` contains runnable products and applications. Each subdirectory is expected to be its own repository or clearly documented working tree.
- `packages/` contains reusable libraries shared by Happy Patterns projects.
- `docs/governance/` contains Happy Patterns-authored operating standards and restatements.
- `records/` contains local-only custody material and is outside routine development work.

Future workspace lanes such as `infrastructure/` should get a short local contract before repos are moved into them.

## Change Flow

1. Confirm the active directory and repository status.
2. Read the local root contracts, then any project-level contracts for the files being changed.
3. Make the smallest coherent change that satisfies the task.
4. Run the project's documented checks. If there is no project check, run the narrowest useful validation available.
5. Report what changed, what was validated, and any remaining risk or follow-up.

Do not commit, push, relocate repositories, or change shared infrastructure unless the owner explicitly asks for that action.

## Branches, Commits, and PRs

Use Conventional Commits:

```text
type(scope): subject
```

Common types are `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `perf`, `ci`, and `build`.

Keep history linear. Use owner-reviewed pull requests for production-bearing repositories. Do not bypass hooks, checks, or review gates without explicit owner approval and a recorded reason.

## Review Standard

A good Happy Patterns change is:

- clear about the problem it solves
- small enough to review
- tested in proportion to risk
- honest about what was not verified
- safe with secrets and private data
- consistent with the project's existing patterns

When work affects security, privacy, customer-facing behavior, public APIs, pricing, contracts, production systems, or legal obligations, stop and ask the owner before proceeding.

## Website and Infrastructure Notes

The public website belongs in `apps/` once explicitly relocated. DNS imports, rough plans, and temporary notes should be classified before they can become public site history.

Development infrastructure needs a dedicated Happy Patterns-local lane and a secrets/status review before it is moved into the active workspace.

Legacy MAAT material is not part of the active Happy Patterns workspace. Treat it as external experimental material unless a future task explicitly transfers bounded, cleaned-up pieces.

---

Last updated: 2026-05-01
