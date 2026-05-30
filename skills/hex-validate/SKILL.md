---
name: hex-validate
description: >
  Slash command /hex-validate. Runs the hexagonal boundary check against the
  current workspace. Ensures domain layer code does not import infrastructure
  packages. Used as a verification gate by the Main Coordinator in /goal execution.
---

# Hexagonal Boundary Validation

## Trigger
Custom slash command: `/hex-validate`

## What It Checks
Scans all files in the domain layer directories (`internal/domain/`, `internal/core/domain/`,
`src/domain/`, `lib/domain/`) for imports of infrastructure packages:
- `database/sql`, `lib/pq`, `cloud.google.com/go` (Go DB/GCS drivers)
- `net/http`, `os/exec` (Go transport/process)
- `docker`, `k8s.io` (container infrastructure)

## Instructions
1. Execute: `bash scripts/hex-validate.sh` (or `~/.gemini/scripts/hex-validate.sh`)
2. If exit code is 1:
   - Read the violation output to identify which files are the problem.
   - Move the offending import into the `/internal/adapters/` layer.
   - Define a port interface in the domain layer that the adapter implements.
   - Re-run `/hex-validate` until it passes.
3. If exit code is 0: Report "✅ hex-validate PASSED" to the Coordinator.

## Integration
This gate is run by:
- The Main Coordinator at the end of every `/goal` execution
- The `scripts/pre-commit` hook before every git commit
