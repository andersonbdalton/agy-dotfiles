# Antigravity 2.0 Global Dotfiles (~/.gemini/antigravity-cli/)

This repository contains the global configuration profile, scripts, custom tools, and multi-agent swarm rulesets for the Antigravity 2.0 runtime environment.

## Environment Description
- **Execution Engine:** Go-powered Antigravity 2.0 CLI (`agy`).
- **Operation Mode:** 100% Unrestricted YOLO Mode with automated, no-confirmation process execution (`terminal_execution_policy: "always-proceed"`, `file_mutation_policy: "always-proceed"`).
- **Containment Mode:** Native Terminal Sandbox utilizing light-weight, OS-level container isolation (`sandbox_mode: "os_isolation"`).
- **Automated Model Escalation:** Hot-swapping to Gemini 3.1 Pro when a subagent hits a reasoning roadblock (3 consecutive failures).
- **Context Caching:** Direct caching of large codebase contexts on Google's API servers to reduce API costs by up to 90% and increase speed.

## Directory Structure Map
- `settings.json`: Master runtime tuning parameters, permissions settings, and LLM configuration rules (including caching and auto-escalation).
- `hooks.json`: Declarative JSON hooks definition that intercepts CLI lifecycle events (e.g., executing a pre-run linter check before any terminal run command).
- `scripts/`: Directory housing global validator and linting helper scripts:
  - `global_linter_check.sh`: Quick security and purity script triggered by the hooks engine.
  - `pre-commit`: Native pre-commit hook script executing hexagonal boundary and security checks automatically.
- `skills/`: Global capabilities catalog mapping custom skills, including:
  - `unrestricted-architect/SKILL.md`: Grandmaster rulesets for running complex autonomous agent swarms.

## Machine 2 Setup & Mirror Instructions
To mirror this configuration instantly on a second machine, run the following commands:

```bash
# 1. Create the destination folder path
mkdir -p ~/.gemini/antigravity-cli/

# 2. Clone the configuration files directly into the global space
git clone https://github.com/andersonbdalton/agy-dotfiles.git ~/.gemini/antigravity-cli/

# 3. Enable the pre-commit hook by linking it to git templates or active repositories
ln -sf ~/.gemini/antigravity-cli/scripts/pre-commit ~/.gemini/antigravity-cli/.git/hooks/pre-commit
chmod +x ~/.gemini/antigravity-cli/.git/hooks/pre-commit

# 4. Verify directory contents
ls -la ~/.gemini/antigravity-cli/
```
