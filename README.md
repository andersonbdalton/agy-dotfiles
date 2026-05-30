# Antigravity 2.0 Global Dotfiles (~/.gemini/antigravity-cli/)

This repository houses the global configuration profile, shell aliases, custom tools, and multi-agent swarm rulesets for the Antigravity 2.0 runtime environment.

## Core Summary
- **Execution Engine:** Go-powered Antigravity 2.0 CLI (`agy`).
- **Operation Mode:** 100% Unrestricted YOLO Mode with automated, no-confirmation process execution (`terminal_execution_policy: "always-proceed"`, `file_mutation_policy: "always-proceed"`).
- **Containment Mode:** Native Terminal Sandbox utilizing light-weight, OS-level container isolation (`sandbox_mode: "os_isolation"`).
- **Automated Model Escalation ("Brain Swap"):** Automatically transitions subagent reasoning from Gemini 3.5 Flash to Gemini 3.1 Pro when hitting a roadblock (3 consecutive failures).
- **Context Caching:** Native caching of repository structure and codebase schemas directly on Google's API servers to cut costs by up to 90% and accelerate speeds.

## Core Tool Blueprint

### 6 Custom Action Modules

Our background engine is equipped with 6 custom commands deployed globally to enforce architectural boundaries and verify system health:

1. **`/hex-validate` (Core Purity Checker):** Compiles and runs a hexagonal architecture checker verifying that core domain logic has zero dependencies on infrastructure, databases, or web frameworks.
2. **`/sec-audit` (The Security Shield):** Runs code scans searching for hardcoded keys, secrets, and checks third-party dependencies for known vulnerabilities.
3. **`/ui-lint` (Framework-Agnostic Interface Validator):** Automatically validates type-safety, accessibility standards, and styling design tokens inside presentational layers.
4. **`/mock-verify` (Synthetic Data Schema Gatekeeper):** Programmatically validates generated synthetic datasets (JSON, CSV, SQL) against defined structural schemas.
5. **`/clean-room` (The Workspace Janitor):** Forcefully purges build caches, lockfile collisions, and loose tracking artifacts to maintain performance.
6. **`/test-matrix` (Automated Integration Test Runner):** Automatically discovers and executes unit, integration, and E2E test suites inside the local workspace.

### 5-Agent Swarm Topology

For complex objectives, the Coordinator spawns a specialized swarm partitioned as follows:

*   **Subagent 1 (The Domain Engineer):** Focuses solely on business logic, rule definitions, and ports interfaces, with zero awareness of infrastructure or frameworks.
*   **Subagent 2 (The Adapter Integrator):** Confined to implementation files (SQL queries, APIs, message brokers) that satisfy the ports defined by Subagent 1.
*   **Subagent 3 (The UI Architect):** Handles presentation layouts and interactive components using fluid utility layouts tied strictly to central design tokens.
*   **Subagent 4 (The Security & Compliance Officer):** Inspects changes, runs `/sec-audit`, verifies authentication middleware, and prevents vulnerable packages from being introduced.
*   **Subagent 5 (The Automated QA & Testing Suite):** Launches dev servers, mounts mock datasets, and drives `/browser` tool execution to visually verify layout responsiveness.

## Migration Guide & Setup Instructions

To mirror this configuration instantly on a second machine, run the following commands:

```bash
# 1. Create the destination folder path
mkdir -p ~/.gemini/antigravity-cli/

# 2. Clone the configuration files directly into the global space
git clone https://github.com/andersonbdalton/agy-dotfiles.git ~/.gemini/antigravity-cli/

# 3. Setup the pre-commit hook in the repository
ln -sf ~/.gemini/antigravity-cli/scripts/pre-commit ~/.gemini/antigravity-cli/.git/hooks/pre-commit
chmod +x ~/.gemini/antigravity-cli/.git/hooks/pre-commit

# 4. Verify directory contents
ls -la ~/.gemini/antigravity-cli/
```
