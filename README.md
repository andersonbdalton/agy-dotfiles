# Antigravity 2.0 Global Dotfiles (~/.gemini/antigravity-cli/)

This repository houses the global configuration profile, shell aliases, custom tools, and multi-agent swarm rulesets for the Antigravity 2.0 runtime environment.

## 1. Core Environment Summary
- **Execution Engine:** Go-powered Antigravity 2.0 CLI (`agy`).
- **Operation Mode:** 100% Unrestricted YOLO Mode with automated, no-confirmation process execution (`terminal_execution_policy: "always-proceed"`, `file_mutation_policy: "always-proceed"`).
- **Containment Mode:** Native Terminal Sandbox utilizing light-weight, OS-level container isolation (`sandbox_mode: "os_isolation"`).
- **Automated Model Escalation ("Brain Swap"):** Automatically transitions subagent reasoning from Gemini 3.5 Flash to Gemini 3.1 Pro when hitting a roadblock (3 consecutive failures).
- **Context Caching:** Native caching of repository structure and codebase schemas directly on Google's API servers to cut costs by up to 90% and accelerate speeds.

## 2. Directory Structure Map
- `settings.json`: Master runtime tuning parameters, permissions settings, and LLM configuration rules.
- `hooks.json`: Declarative JSON hooks definition that intercepts CLI lifecycle events (e.g., executing a pre-run linter check before any terminal run command).
- `scripts/`: Directory housing global validator and linter helper scripts:
  - `global_linter_check.sh`: Quick security and purity script triggered by the hooks engine.
  - `pre-commit`: Native pre-commit hook script executing hexagonal boundary and security checks automatically.
- `skills/`: Global capabilities catalog mapping custom skills, including:
  - `unrestricted-architect/SKILL.md`: Grandmaster rulesets for running complex autonomous agent swarms.
  - `hex-validate/SKILL.md`, `sec-audit/SKILL.md`, `ui-lint/SKILL.md`, `mock-verify/SKILL.md`, `clean-room/SKILL.md`, `test-matrix/SKILL.md`: Declarative triggers for the 6 custom actions.

## 3. Global settings.json Blueprint
```json
{
  "colorScheme": "tokyo night",
  "enableTelemetry": false,
  "permissions": {
    "allow": [
      "command(*)",
      "read_file(*)",
      "write_file(*)",
      "mcp(*)",
      "read_url(*)"
    ]
  },
  "trustedWorkspaces": [
    "C:\\Users\\dalt"
  ],
  "engine": {
    "default_model": "gemini-3.5-flash",
    "fallback_model": "gemini-3.1-pro",
    "auto_escalate_on_failure_count": 3,
    "verbosity_level": "low",
    "context_compaction_threshold": 135000,
    "max_recursive_loops_per_task": 25
  },
  "caching_policy": {
    "enable_prompt_context_caching": true,
    "ttl_minutes": 120,
    "min_cache_input_tokens": 32768
  },
  "runtime_permissions": {
    "terminal_execution_policy": "always-proceed",
    "file_mutation_policy": "always-proceed",
    "network_access_policy": "always-proceed",
    "allow_destructive_commands": true,
    "sandbox_mode": "os_isolation"
  },
  "visual_verification": {
    "auto_headless_browser_tests": true,
    "capture_artifacts_on_failure": true
  }
}
```

## 4. Unrestricted Terminal Shell Aliases
Add these to your `~/.zshrc` or `~/.bashrc` shell profiles:
```bash
# Force agy into full execution mode with zero prompt restrictions
alias agy-yolo="agy --dangerously-skip-permissions"

# Immediate query monitor to view parallel subagent workloads
alias agy-monitor="agy /agents"

# Instantly reload your previous terminal context state
alias agy-resume="agy /resume"
```

## 5. Custom Action Catalog (6 Custom Tools)

### `/hex-validate` (Core Purity Checker)
- **Script (`skills/hex-validate/scripts/validate.sh`):**
```bash
#!/bin/bash
echo "?? Running Hexagonal Boundary Analysis..."
if grep -rE "gorm.io|github.com/lib/pq|gin-gonic" ./internal/domain/; then
    echo "? ARCHITECTURAL VIOLATION: Core domain logic cannot import infrastructure drivers!"
    exit 1
fi
echo "? Architecture is pure. Bound checks passed cleanly."
exit 0
```
- **Trigger (`skills/hex-validate/SKILL.md`):** Custom slash command `/hex-validate`.

### `/sec-audit` (The Security Shield)
- **Script (`skills/sec-audit/scripts/audit.sh`):**
```bash
#!/bin/bash
echo "??? Running Enterprise Security & Secret Audit..."
if grep -rE "sk_live_|AIzaSy|passwd=|SECRET_KEY=" ./src/ ./internal/; then
    echo "? SECURITY VIOLATION: Hardcoded credentials or API keys detected!"
    exit 1
fi
if [ -f "go.mod" ]; then go install golang.org/x/vuln/cmd/govulncheck@latest && govulncheck ./... || exit 1; fi
if [ -f "Cargo.toml" ]; then cargo audit || exit 1; fi
echo "? Security posture is clean. Audit passed."
exit 0
```
- **Trigger (`skills/sec-audit/SKILL.md`):** Custom slash command `/sec-audit`.

### `/ui-lint` (Interface Validator)
- **Trigger (`skills/ui-lint/SKILL.md`):** Custom slash command `/ui-lint`.

### `/mock-verify` (Synthetic Data Schema Gatekeeper)
- **Trigger (`skills/mock-verify/SKILL.md`):** Custom slash command `/mock-verify`.

### `/clean-room` (Workspace Janitor)
- **Script (`skills/clean-room/scripts/clean.sh`):**
```bash
#!/bin/bash
echo "?? Initializing Workspace Clean Room..."
if [ -d "node_modules" ]; then rm -f package-lock.json yarn.lock; fi
if [ -f "go.sum" ]; then go clean -cache -modcache; fi
if [ -d "target" ]; then cargo clean; fi
git clean -fdx --exclude=.agents/ --exclude=.gemini/
echo "? Workspace reset to an absolute clean-room state."
exit 0
```
- **Trigger (`skills/clean-room/SKILL.md`):** Custom slash command `/clean-room`.

### `/test-matrix` (Automated Integration Test Runner)
- **Trigger (`skills/test-matrix/SKILL.md`):** Custom slash command `/test-matrix`.

## 6. Model Context Protocol Configuration (`mcp_config.json`)
**File Target Location:** `.agents/mcp_config.json`
```json
{
  "mcpServers": {
    "local-postgres-schema": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres", "--connection-string", "postgresql://localhost/wholesale_db"],
      "description": "Gives subagents absolute, real-time context of the physical database schemas to prevent structural hallucinations."
    },
    "github-issue-sync": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "your_token_here"
      },
      "description": "Allows background janitors to independently check open tickets and track system requirements."
    }
  }
}
```

## 7. Nightly Janitor Cron Background Process (`/schedule`)
```text
/schedule create "nightly-workspace-janitor" --cron "0 2 * * *" --goal "Perform system maintenance. Pull the latest code on the main branch, execute a package vulnerability sweep, fix non-breaking patches in an isolated Git worktree, verify compilation via standard test runners, and prepare a clean summary Pull Request. Set an execution cap of 5 recursive correction loops."
```

## 8. Supreme Macro Task Prompt (Version 3.0)
Use this template to trigger an enterprise-scale epic inside `agy-yolo`:
```text
/goal Execute the complete end-to-end implementation of [Core Feature Name].

[1. SYSTEM OBJECTIVE]
- High-level design: Build [Describe feature or multi-agent pipeline requirements].
- Target Modules: [e.g., /internal/adapters/api or /src/components]

[2. ARCHITECTURAL BOUNDARIES]
- Enforce strict Hexagonal / Modular design patterns based on the unrestricted-architect skill rules.
- Keep data layers completely separated from infrastructural drivers or visual presentation engines.

[3. AUTONOMOUS RUNTIME & COST-CONTROL EXPECTATIONS]
- You are running in Full YOLO Mode with Native OS Isolation Sandboxing and Server Context Caching activated.
- To prevent token waste, sub-agents must be spawned ON-DEMAND. A Core Agent Director must only call a Specialist Sub-Agent if a task requires deep contextual generation, refactoring, or infrastructure creation. Shut down sub-agents immediately upon task resolution.

[4. SUBAGENT TOPOLOGY AND NESTED ROUTING]
When executing this objective, spawn the 5 Core Agent Directors. Instruct each Director to autonomously spawn and manage its respective Specialist Sub-Agents as needed:

- 1. The Domain Engineer (Director)
  - Scope: Confined strictly to core business models and interfaces (/internal/domain/).
  - Nested Specialist Sub-Agent:
    * The Migration & Refactoring Specialist: Triggered only for modernizing legacy code blocks, mapping type-safety systems, or migrating file configurations (e.g., JS to TS, REST to GraphQL).

- 2. The Adapter Integrator (Director)
  - Scope: Infrastructure implementations, network channels, and external database adapters.
  - Nested Specialist Sub-Agents:
    * The Database Schema Engineer: Triggered to inspect data models, generate SQL migration scripts, build indexes, and draft rollbacks.
    * The Docker/K8s Configurator: Triggered to build container manifests, write Kubernetes YAMLs, and debug docker-compose loops.
    * The CI/CD Pipeline Architect: Triggered exclusively to generate and debug pipeline automations (e.g., GitHub Actions workflows).

- 3. The UI Architect (Director)
  - Scope: Presentational layouts, interactive screen states, and framework-agnostic client data layers.
  - Nested Specialist Sub-Agents:
    * The Synthetic Data Generator: Triggered to generate high-fidelity, schema-compliant mock data (JSON, CSV, SQL dumps) for early UI parsing.
    * The Documentation Writer: Triggered to scan layouts and endpoints to generate OpenAPI/Swagger schemas and update workspace README profiles.

- 4. The Security & Compliance Officer (Director)
  - Scope: Complete repository vulnerability gates, secret tracking, and compliance enforcement.
  - Nested Specialist Sub-Agents:
    * The Code Reviewer / Linter: Triggered to intercept code diffs, audit syntax formatting, identify performance bottlenecks, and flag code smells.
    * The Dependency Validator: Triggered to analyze package manifests for CVE vulnerabilities, clear outdated libraries, and update lockfiles securely.

- 5. The Automated QA & Testing Suite (Director)
  - Scope: Live terminal process execution and headless browser testing verification loops.
  - Nested Specialist Sub-Agents:
    * The Test Generator: Triggered to read test coverage reports and write targeted unit/integration tests to eliminate untested logic gaps.
    * The UI Regression Auditor: Triggered to launch headless browser runs, capturing responsive layout screenshots to run visual diff audits.
    * The Accessibility Checker: Triggered to audit rendered HTML structures for screen-reader paths, keyboard traps, and ARIA labels.
    * The Log Interpreter / Production Debugger: Triggered if compilation or integration tests crash; parses raw stack traces and server outputs to feed structural patches back to the swarm.

[5. VERIFICATION AND EXIT PARAMETERS]
- Do not stop executing until the local test matrix passes with a 100% success rate.
- The Main Coordinator Agent acts as the supreme arbiter—synthesizing code from the departments, executing global slash commands (/hex-validate, /sec-audit, /ui-lint), and verifying that the Security and QA Directors have formally signed off on the build before marking the /goal as complete.
```

## 9. Migration Guide & Setup Instructions

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