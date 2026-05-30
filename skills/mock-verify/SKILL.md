# Mock Data Verification Action
## Description
Programmatically validates generated synthetic datasets against the repository's core structural JSON schemas.
## Triggers
- Custom slash command: `/mock-verify`
## Instructions
1. Locate newly generated JSON, CSV, or SQL data files in the scratch directories.
2. Run a validation pass checking schema properties, data types, and null constraints against the central domain contracts.
