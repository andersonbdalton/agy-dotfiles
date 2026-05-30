---
name: test-matrix
description: >
  Defines and executes the test matrix for a feature. Used by Director 3 (QA & Security)
  to generate and run unit + integration tests. Part of the /goal exit conditions.
---

# Test Matrix Runner

## Trigger
Used inline by Director 3 during `/goal` execution. Also invokable as `/test-matrix`.

## What It Does
1. Reads existing test coverage reports (if available).
2. Identifies untested code paths in recently modified files.
3. Generates targeted unit and integration tests to close the gaps.
4. Runs the full test suite and reports pass/fail.

## Minimum Acceptance Bar
For a `/goal` to be marked complete, the test matrix must confirm:
- [ ] The happy path of every new endpoint or function is tested
- [ ] At least one error/failure case per new function is tested
- [ ] No existing tests were broken (regression check)

## Instructions
1. Identify modified files from the current git diff: `git diff --name-only HEAD`
2. For each modified Go file: check `go test ./...` output for coverage
3. For each modified Rust file: check `cargo test` output
4. For each modified TS/JS file: check `npm test` or `vitest run` output
5. Write new tests to fill gaps. Place them adjacent to the source file:
   - Go: `*_test.go` in the same package
   - Rust: `#[cfg(test)] mod tests` block at bottom of the `.rs` file
   - TypeScript: `*.test.ts` next to the source file
6. Re-run tests until all pass.
7. Report results to Director 3 for sign-off.

## Integration
Run by Director 3 after all code changes are complete, before the Coordinator
runs the final `/hex-validate` and `/sec-audit` gates.
