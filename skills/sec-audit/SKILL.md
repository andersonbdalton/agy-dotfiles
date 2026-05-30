---
name: sec-audit
description: >
  Slash command /sec-audit. Runs the security audit gate against the current workspace.
  Scans for hardcoded secrets, runs govulncheck/cargo-audit/npm audit for CVEs.
  Used as a verification gate by Director 3 and the Main Coordinator in /goal execution.
---

# Security Audit Gate

## Trigger
Custom slash command: `/sec-audit`

## What It Checks
1. **Hardcoded secrets** — Scans all source files for patterns matching passwords,
   API keys, tokens, private keys, and cloud credentials.
2. **Go CVEs** — Runs `govulncheck ./...` if available and a `go.mod` exists.
3. **Rust CVEs** — Runs `cargo audit` if available and a `Cargo.toml` exists.
4. **Node CVEs** — Runs `npm audit --audit-level=high` if a `package.json` exists.

## Instructions
1. Execute: `bash scripts/sec-audit.sh` (or `~/.gemini/scripts/sec-audit.sh`)
2. If exit code is 1:
   - For hardcoded secrets: Move values to environment variables or Secret Manager.
   - For CVEs: Run `go get -u`, `cargo update`, or `npm update` for the flagged packages.
   - Re-run `/sec-audit` until it passes.
3. If exit code is 0: Report "✅ sec-audit PASSED" to the Coordinator.

## Integration
This gate is run by:
- Director 3 (QA & Security) during any feature implementation
- The Main Coordinator at the end of every `/goal` execution
- The `scripts/pre-commit` hook before every git commit
