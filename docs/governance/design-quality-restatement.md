# Design Quality Restatement

This is Happy Patterns' working standard for judging whether software, tooling, automation, and supporting operations are ready to rely on.

Design quality here means more than visual polish or code style. A design is good when its purpose is clear, ownership is named, access is limited, behavior is testable, state can be recovered, and the people using or maintaining it can understand what will happen next.

## Scope

This restatement applies to Happy Patterns work across applications, shared packages, internal tools, website work, and development operations.

Use judgment. A small local script does not need the same ceremony as a production application, but every artifact should have an owner, a purpose, and a safe way to change or retire it.

## Quality Expectations

### Named Ownership

Every meaningful system, repository, service, workflow, dataset, credential path, vendor account, and operational process needs a clear owner or owner group. If nobody owns it, it should not become load-bearing.

### Clear Purpose

Each artifact should state what it is for, who it serves, and what it deliberately does not do. Avoid vague platforms and open-ended machinery unless the near-term use is concrete.

### Small Durable Surface

Prefer the smallest stable interface that solves the problem. Keep APIs, schemas, permissions, network exposure, data retention, and configuration surface area limited and intentional.

### Least Access

Grant only the access needed for the task. Credentials and permissions should be scoped, documented, revocable, and kept out of git.

### Auditable Change Path

Important changes should leave a trail: issue, commit, pull request, decision note, runbook update, test output, or deployment record. The right form depends on risk, but silent changes should not become routine.

### Testable Behavior

Critical behavior should be reproducible in local checks, automated tests, smoke tests, screenshots, logs, or other evidence appropriate to the artifact. If something cannot be verified yet, say that explicitly.

### Runtime Visibility

Production-bearing systems need enough logging, health checks, metrics, or operational inspection to distinguish expected behavior from failure. Development-only tools should still fail in ways a maintainer can diagnose.

### Recoverable State

State should have a known home, backup expectation, migration story, or reset path. If data would be expensive or impossible to recreate, recovery needs to be part of the design.

### Dependency Discipline

Dependencies should have a purpose, a maintainer signal, a license posture, and an update path. Do not add new services, SDKs, or runtime frameworks casually.

### Lifecycle Clarity

Experiments, prototypes, temporary scripts, and archived material should be labeled as such. Active work should have a path to maintenance; inactive work should have a path to retirement or quarantine.

## Risk Levels

Use these levels to scale review and evidence:

- **Level 0 - Notes and local drafts:** low-risk planning material; keep it clearly non-authoritative.
- **Level 1 - Local developer tooling:** scripts and helpers that affect one workstation or one working tree.
- **Level 2 - Shared project behavior:** code, configuration, tests, documentation, or workflows used by a team or product repository.
- **Level 3 - Production-bearing systems:** deployed applications, domains, CI/CD, secrets paths, data stores, monitoring, and customer-facing support paths.
- **Level 4 - Business-critical decisions:** legal, financial, contractual, privacy, security, or customer-trust decisions. These require owner direction before action.

## Evidence Expectations

Good evidence can include:

- passing checks or tests
- local smoke-test output
- screenshots or rendered previews
- reviewed diffs
- explicit decision notes
- redacted logs
- runbook updates
- rollback or recovery notes

Evidence should be useful without exposing secrets, private records, or customer data.

## Stop Conditions

Stop and ask the owner before proceeding when a change would:

- expose or move credentials
- alter privacy, security, or retention behavior
- change public APIs, schemas, domains, DNS, or production deployment paths
- bind Happy Patterns to a vendor, contract, price, legal position, or customer commitment
- move repositories into a new active workspace lane without a local lane contract
- make legacy experimental material look active without cleanup and review

## Practical Checklist

Before treating work as ready, confirm:

- the owner and purpose are clear
- the change is scoped and reviewable
- secrets and private records stay out of git
- the verification level matches the risk
- the rollback or recovery story is known for load-bearing systems
- temporary or legacy material is labeled honestly
- follow-up work is recorded rather than hidden in local state

---

Last updated: 2026-05-01
