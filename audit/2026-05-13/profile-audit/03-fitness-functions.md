# Candidate Future Fitness Functions

These are candidate checks only. They are not current findings, not implemented controls, and not remediation instructions.

## FF-001 - Root Contract Parity

Check that root `AGENTS.md` and `CLAUDE.md` either match exactly or differ only in an explicit, reviewed tool-shim section. Fail on drift inside scope, project-context, authority-tier, boundary, secrets, or records language.

## FF-002 - Root README Shape Truth

Check that `README.md` does not claim the Happy Patterns root is not a git repository when `.git/` exists and tracked root shell files are present.

## FF-003 - Ignored Agent Settings Manifest

Inventory ignored `.claude/settings*.json`, `.codex/*`, and `.agents/*` surfaces under the root and nested projects. Require each ignored settings file with provider, broad read, or write capability to be classified as local-only, project policy, or stale.

## FF-004 - External Authority Reference Scan

Scan root and app `.envrc`, agent settings, prompts, and SOP surfaces for references to authority paths outside `/Users/verlyn13/Organizations/happy-patterns`. Report them as external references unless a Happy Patterns-local doc explicitly adopts them.

## FF-005 - Records Local-Only Guard

For `records`, check all of:

- no git remote,
- status clean or explicitly acknowledged,
- no provider-push workflow,
- no credentials/recovery-code/private-key files tracked,
- no markdown transcription of signed legal material unless records authority allows it.

## FF-006 - Records Inventory Classification

Require root audit/status packets to classify `records` as local custody, not development context, and to avoid opening legal/tax/formation record contents unless explicitly authorized.

## FF-007 - Nested Repo Dirty-State Gate

Before subsidiary-level audits, collect read-only `git status --short --branch` and HEAD for each visible nested repo. If a nested repo is dirty, mark all nested status claims as caveated.

## FF-008 - ScopeCam Toolchain Pin Consistency

Compare `apps/scopecam/gradle/libs.versions.toml` toolchain pins against `apps/scopecam/docs/STATUS.md` toolchain claims. Report drift without remediation.

## FF-009 - Workflow Trigger Classifier

Classify every `.github/workflows/*` file by trigger and provider reach:

- PR/merge-group gate,
- scheduled,
- workflow-dispatch,
- release,
- deploy/publication,
- optional smoke,
- report-only.

Do not classify any workflow as required/blocking unless live ruleset evidence is attached.

## FF-010 - Manual Provider Workflow Stop Rule

Fail any audit plan that attempts to dispatch release, app distribution, Firebase Test Lab, OIDC debug, or other provider workflows. Audit classification should remain source-defined unless the owner authorizes provider verification.

## FF-011 - Public Site Deployment Evidence Check

For `apps/happy-patterns-org.github.io`, require a source-defined vs provider-verified classification for GitHub Pages and custom-domain claims. Local `CNAME` is source evidence; current Pages provider state requires explicit provider authorization.

## FF-012 - Website Production-Branch Action Check

Flag local agent settings that allow `git commit` on a website repo whose publication path is `main`. This is not automatically wrong, but should be visible when the repo claims push-to-main deployment.

## FF-013 - Prompt/SOP Classification Check

Require ignored relocation plans, DNS imports, rough plans, and temporary SOP files to be labeled as current, superseded, evidence, or scratch before they are used in publication or governance reasoning.

## FF-014 - Hook Write-Capability Check

Inventory git hooks, lefthook/pre-commit configs, and formatters that write or stage files. Classify each as local convenience, policy guardrail, or required CI enforcement.

## FF-015 - Provider Secret Path Redaction Check

Audit packets may reference files and line numbers for secret-loading surfaces, but should avoid copying secret values and should avoid normalizing provider item paths into policy unless Happy Patterns-local authority owns that naming.

## FF-016 - ScopeCam Local Settings Narrowness Check

Flag ignored local settings that allow broad home-directory reads, provider CLI writes, device/network operations, or destructive cleanup commands. Require classification as local-only convenience or removal from project assumptions.

## FF-017 - No Cross-Subsidiary Vocabulary Import

Check Happy Patterns root audit packets for governing identifiers imported from outside Happy Patterns. Allow references to nested Happy Patterns project-local identifiers only when scoped to that nested project and not presented as subsidiary-root authority.

## FF-018 - Root Audit Packet Secret Scan

Run a high-confidence secret-pattern scan over generated audit packets before handoff. The scan should catch common token/private-key forms while avoiding false positives from generic words such as "token" in descriptions.
