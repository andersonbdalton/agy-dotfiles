# Hexagonal Validation Action
## Description
Physically compiles and runs a boundary check script against the local workspace to block architectural leaks.
## Triggers
- Custom slash command: `/hex-validate`
## Instructions
1. Execute the local shell asset natively: `./scripts/validate.sh`
2. If it exits with code 1, abort operations and refactor the infrastructure out of the domain layer.
