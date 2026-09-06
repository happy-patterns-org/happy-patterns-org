#!/bin/sh
# check-root-contracts.sh — mechanizes two candidate fitness functions from
# audit/2026-05-13/profile-audit/03-fitness-functions.md:
#
#   FF-001 Root Contract Parity    root AGENTS.md and CLAUDE.md must match exactly.
#   FF-002 Root README Shape Truth README.md must not misdescribe the root's shape.
#
# Dependency-free POSIX sh; uses only cmp, diff, grep and test. No network, no git
# subcommands, no writes. Reads exactly three root files plus the NAMES of .git and
# audit/ — it never opens anything under audit/.
#
# Usage:  sh tools/check-root-contracts.sh [repo-root]
# Exit:   0 = both hold   1 = drift (message names it)   2 = usage error

set -u

ROOT=${1:-$(CDPATH= cd -- "$(dirname -- "$0")/.." 2>/dev/null && pwd)}
if [ -z "${ROOT:-}" ] || [ ! -d "$ROOT" ]; then
	echo "usage: $0 [repo-root]" >&2
	exit 2
fi

A=$ROOT/AGENTS.md
C=$ROOT/CLAUDE.md
R=$ROOT/README.md

ff1=0
ff2=0
fail() {
	printf 'FAIL  %s\n' "$*" >&2
}

# --- FF-001: root contract parity --------------------------------------------
# AGENTS.md and CLAUDE.md are two independent files whose parity is hand-kept and
# has already broken once (finding F-002). This check is deliberately one bit:
# byte-identical or not. FF-001 also permits a reviewed tool-shim delta; that
# variant is NOT modelled here, so introducing one means amending this check.
if [ ! -f "$A" ] || [ ! -f "$C" ]; then
	ff1=1
	fail "FF-001 parity: expected both AGENTS.md and CLAUDE.md under $ROOT; at least one is missing."
elif cmp -s "$A" "$C"; then
	printf 'ok    FF-001 parity: AGENTS.md and CLAUDE.md are byte-identical\n'
else
	ff1=1
	hunk=$(diff "$A" "$C" | grep -m1 '^[0-9]') || hunk="unknown"
	fail "FF-001 parity: AGENTS.md and CLAUDE.md are NOT byte-identical (first divergence at diff hunk '$hunk'). Re-sync them; do not let the two root contracts drift."
fi

# --- FF-002: README describes the root's real shape ---------------------------
if [ ! -f "$R" ]; then
	ff2=1
	fail "FF-002 README: README.md is missing under $ROOT."
else
	if [ -d "$ROOT/.git" ] || [ -f "$ROOT/.git" ]; then
		if grep -Eqi 'not a git (repo|repository)' "$R"; then
			ff2=1
			fail "FF-002 README: README.md states the root is NOT a git repository, but $ROOT/.git exists. This is exactly finding F-001."
		fi
		if ! grep -Eqi 'root is a[^.]*git[^.]*repo' "$R"; then
			ff2=1
			fail "FF-002 README: $ROOT IS a git repository, but README.md never says so (no sentence matching /root is a...git...repo/)."
		fi
	fi
	if [ -d "$ROOT/audit" ]; then
		if ! grep -q 'audit/' "$R"; then
			ff2=1
			fail "FF-002 README: audit/ exists at the root but README.md documents no audit lane."
		fi
	elif grep -q 'audit/' "$R"; then
		ff2=1
		fail "FF-002 README: README.md documents an audit/ lane, but no audit/ directory exists under $ROOT."
	fi
	[ "$ff2" -eq 0 ] && printf 'ok    FF-002 README: root-is-a-git-repo and audit/ lane both match reality\n'
fi

[ "$ff1" -eq 0 ] && [ "$ff2" -eq 0 ] && exit 0
exit 1
