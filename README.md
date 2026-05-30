# Antigravity 2.0 Global Dotfiles (~/.gemini/antigravity-cli/)

This repository contains the global configuration profile, scripts, custom tools, and multi-agent swarm rulesets for the Antigravity 2.0 runtime environment.

## Environment Description
- **Execution Engine:** Go-powered Antigravity 2.0 CLI (`agy`).
- **Operation Mode:** 100% Unrestricted YOLO Mode with automated, no-confirmation process execution (`terminal_execution_policy: "always-proceed"`, `file_mutation_policy: "always-proceed"`).
- **Containment Mode:** Native Terminal Sandbox utilizing light-weight, OS-level container isolation (`sandbox_mode: "os_isolation"`).

## Directory Structure Map
- `settings.json`: Master runtime tuning parameters, permissions settings, and LLM configuration rules.
- `hooks.json`: Declarative JSON hooks definition that intercepts CLI lifecycle events (e.g., executing a pre-run linter check before any terminal run command).
- `scripts/`: Directory housing global validator and linting helper scripts:
  - `global_linter_check.sh`: Quick security and purity script triggered by the hooks engine.
- `skills/`: Global capabilities catalog mapping custom skills, including:
  - `unrestricted-architect/SKILL.md`: Grandmaster rulesets for running complex autonomous agent swarms.

## Machine 2 Setup & Mirror Instructions
To mirror this configuration instantly on a second machine, run the following commands:

```bash
# 1. Create the destination folder path
mkdir -p ~/.gemini/antigravity-cli/

# 2. Clone the configuration files directly into the global space
git clone https://github.com/andersonbdalton/agy-dotfiles.git ~/.gemini/antigravity-cli/

# 3. Verify directory contents
ls -la ~/.gemini/antigravity-cli/
```
