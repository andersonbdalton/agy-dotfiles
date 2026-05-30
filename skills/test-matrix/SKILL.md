# Test Matrix Execution Action
## Description
Discovers, maps, and executes the comprehensive unit, integration, and end-to-end testing frameworks found in the workspace.
## Triggers
- Custom slash command: `/test-matrix`
## Instructions
1. Automatically run the local project testing tools (`go test ./...`, `npm run test`, etc.).
2. If failures arise, capture the stack trace and pass it back to the active subagent loop for self-correction refactoring.
