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

### V3 Hierarchical Swarm Topology & Router-Worker Design

For complex, enterprise-scale objectives, the Coordinator spawns a hierarchical network of 5 Core Agent Directors. Each Director autonomously manages nested Specialist Worker sub-agents on-demand:

*   **1. The Domain Engineer (Director):** Confined strictly to core business models and interfaces (`/internal/domain/`).
    *   *Worker: The Migration & Refactoring Specialist:* Triggered for modernizing legacy code (e.g., JS to TS, REST to GraphQL).
*   **2. The Adapter Integrator (Director):** Confined to infrastructure implementations and database adapters.
    *   *Worker: The Database Schema Engineer:* Generates SQL migration scripts, builds indexes, and drafts rollbacks.
    *   *Worker: The Docker/K8s Configurator:* Builds container manifests and debugs local container loops.
    *   *Worker: The CI/CD Pipeline Architect:* Configures workflows (e.g., GitHub Actions).
*   **3. The UI Architect (Director):** Handles layouts, screen states, and framework-agnostic client data layers.
    *   *Worker: The Synthetic Data Generator:* Populates schema-compliant mock data (JSON, CSV, SQL).
    *   *Worker: The Documentation Writer:* Generates OpenAPI/Swagger specs and keeps docs updated.
*   **4. The Security & Compliance Officer (Director):** Manages repository security gates and secret tracking.
    *   *Worker: The Code Reviewer / Linter:* Audits code changes and identifies syntax issues/code smells.
    *   *Worker: The Dependency Validator:* Checks manifests for CVE vulnerabilities and updates lockfiles.
*   **5. The Automated QA & Testing Suite (Director):** Runs verification checks and browser automation runs.
    *   *Worker: The Test Generator:* Writes unit/integration tests to eliminate coverage gaps.
    *   *Worker: The UI Regression Auditor:* Performs visual regression passes using headless browser captures.
    *   *Worker: The Accessibility Checker:* Scans HTML structures for screen-reader and keyboard compliance.
    *   *Worker: The Log Interpreter / Debugger:* Parses stack traces from build crashes to provide automated patches.

## Migration Guide & Setup Instructions

To mirror this configuration instantly on a second machine, run the following commands based on your operating system:

### 1. Common Initialization (All Operating Systems)

First, initialize the global configuration folder and your central development workspace, then clone the required repositories:

```bash
# Create the global configuration space and clone the dotfiles
mkdir -p ~/.gemini/antigravity-cli/
git clone https://github.com/daltna/agy-dotfiles.git ~/.gemini/antigravity-cli/

# Create your central development workspace folder
mkdir -p ~/dev/

# Navigate to your development workspace to clone your project code
cd ~/dev/
# git clone <your-active-project-repo-url>
```

### 2. OS-Specific Ownership & Permission Settings

Ensure your execution engine has complete ownership and read/write rights over configuration and project workspaces (`~/dev/`):

#### Linux & macOS (Bash/Zsh)
```bash
# Setup the pre-commit hook in the repository
ln -sf ~/.gemini/antigravity-cli/scripts/pre-commit ~/.gemini/antigravity-cli/.git/hooks/pre-commit
chmod +x ~/.gemini/antigravity-cli/.git/hooks/pre-commit

# Secure ownership and permissions recursively
chown -R $(whoami) ~/.gemini/ ~/dev/
chmod -R u+rwx ~/.gemini/ ~/dev/

# Verify directory contents
ls -la ~/.gemini/antigravity-cli/
```

#### Windows (PowerShell - Run as Administrator)
```powershell
# Copy the pre-commit hook script manually
Copy-Item -Path "$HOME\.gemini\antigravity-cli\scripts\pre-commit" -Destination "$HOME\.gemini\antigravity-cli\.git\hooks\pre-commit" -Force

# Secure ownership of settings and development workspaces
takeown /F "$HOME\.gemini" /R /A /D Y
takeown /F "$HOME\dev" /R /A /D Y

# Grant Full Control permissions to the current Windows user
icacls "$HOME\.gemini" /grant "${env:USERNAME}:(OI)(CI)F" /T /C
icacls "$HOME\dev" /grant "${env:USERNAME}:(OI)(CI)F" /T /C

# Verify directory contents
Get-ChildItem -Path "$HOME\.gemini\antigravity-cli"
```

