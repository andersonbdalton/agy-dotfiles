# agy-dotfiles

Global configuration and skill definitions for the **Antigravity AI** development environment.

These dotfiles define how the AI agent behaves, what architecture patterns it enforces,
how it spawns sub-agents, and what verification gates must pass before any work is done.

---

## Structure

```
agy-dotfiles/
├── settings.json          # Engine config: models, permissions, token policy
├── hooks.json             # Lifecycle hooks: compile-on-write, pre-command linting
├── scripts/               # Validation gate shell scripts
│   ├── pre-commit         # Git pre-commit hook (runs all gates)
│   ├── hex-validate.sh    # Hexagonal boundary check
│   ├── sec-audit.sh       # Security audit (secrets + CVE scan)
│   ├── ui-lint.sh         # TypeScript + ESLint + Prettier check
│   ├── verify_go.sh       # go build ./... after .go file writes
│   ├── verify_rust.sh     # cargo check after .rs file writes
│   └── verify_ts.sh       # tsc --noEmit after .ts/.tsx file writes
└── skills/                # Agent skill definitions
    ├── unrestricted-architect/   # V4 lean 3-director swarm
    ├── goal-executor/            # /goal prompt template
    ├── hex-validate/             # /hex-validate slash command
    ├── sec-audit/                # /sec-audit slash command
    ├── ui-lint/                  # /ui-lint slash command
    └── test-matrix/              # Test generation and execution
```

---

## Architecture: Lean 3-Director Swarm (V4)

The agent runs a lean 3-Director topology for maximum quality at minimum token cost.

```
         MAIN COORDINATOR
         (routes, gates, sign-off)
                |
     +----------+----------+
     |          |          |
   [D1]       [D2]       [D3]
Domain &      UI &       QA &
Adapter       Docs      Security
```

| Director | Owns | Spawns Sub-Agent Only When |
|----------|------|---------------------------|
| D1 Domain & Adapter | Models, DB, Docker, CI/CD | 20+ file legacy migration |
| D2 UI & Docs | Components, pages, OpenAPI | Headless browser session needed |
| D3 QA & Security | Tests, lint, CVE, debug | E2E across multiple repos |

Default: Directors work inline. Sub-agents only for isolated, deep-context tasks.

---

## Using /goal

Fill in the brackets and invoke with /goal:

```
/goal Execute [FEATURE NAME]

Objective: [What it does]
Target: [repo/module + entry point files]
Acceptance criteria:
  - [ ] specific outcome
  - [ ] specific outcome

Constraints:
  - Hexagonal boundaries enforced
  - Data layer: [e.g., Cloud SQL + GCS fallback]
  - Auth: [e.g., JWT]

Exit conditions (all must pass):
  - [ ] /hex-validate
  - [ ] /sec-audit
  - [ ] Full build green
  - [ ] Existing tests pass
  - [ ] New tests cover new code paths
  - [ ] /ui-lint (if frontend modified)
```

---

## Verification Gates

| Command | Script | What It Checks |
|---------|--------|----------------|
| /hex-validate | scripts/hex-validate.sh | Domain layer does not import infra |
| /sec-audit | scripts/sec-audit.sh | No secrets, no high CVEs |
| /ui-lint | scripts/ui-lint.sh | tsc, ESLint, Prettier all pass |
| auto | scripts/verify_go.sh | go build after .go writes |
| auto | scripts/verify_rust.sh | cargo check after .rs writes |
| auto | scripts/verify_ts.sh | tsc --noEmit after .ts/.tsx writes |

---

## Setup

Install the git pre-commit hook:
```bash
cp scripts/pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

Install scripts globally (optional):
```bash
mkdir -p ~/.gemini/scripts
cp scripts/*.sh ~/.gemini/scripts/
chmod +x ~/.gemini/scripts/*.sh
```

---

## Token Efficiency Rules

- Sub-agents spawn ON-DEMAND only (default OFF)
- Max 3 concurrent Directors, 2 concurrent Specialists
- Sub-agents auto-killed on task completion
- Parallel writes use branch isolation
- Tasks completable in under 500 lines of output: always inline, never sub-agent
