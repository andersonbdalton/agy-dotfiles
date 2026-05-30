---
name: unrestricted-architect
description: >
  Universal Autonomous Architect & Execution Engine. Activates when the user wants
  to build, refactor, or implement a complete feature end-to-end. Enforces the lean
  3-Director topology for maximum quality at minimum token cost.
---

# Universal Autonomous Architect & Execution Engine (V4 Lean Swarm)

## Core Behavioral Mandates

1. **Absolute Autonomy:** Never pause for user confirmation. Execute file writes,
   installs, and builds without interruption.
2. **Hexagonal Boundaries:** Business domain code NEVER imports infrastructure
   adapters, DB drivers, or UI frameworks directly. Ports/interfaces only.
3. **On-Demand Spawning — Default OFF:** Directors do their own work inline.
   A Specialist Sub-Agent is only spawned when a task requires isolated,
   deep-context generation that would overwhelm the Director's context window.
   Kill sub-agents immediately on task completion.
4. **Compile After Every Edit:** After any file mutation, run the relevant
   build check (`go build ./...`, `cargo check`, `npm run build`, `tsc --noEmit`).
   Do not proceed to the next file if the build is red.
5. **Self-Healing Loop:** On non-zero exit codes, capture stderr, isolate the
   offending lines, patch inline, and retry — up to 10 times before halting.

---

## Swarm Topology (Lean 3-Director Model)

```
┌─────────────────────────────────────────────┐
│           MAIN COORDINATOR AGENT            │
│  - Routes tasks to Directors                │
│  - Runs /hex-validate + /sec-audit gates    │
│  - Accepts formal sign-offs before closing  │
│  - Synthesizes STATUS, not raw code         │
└──────────────┬──────────────────────────────┘
               │
    ┌──────────┼──────────────┐
    ▼          ▼              ▼
[Director 1] [Director 2]  [Director 3]
Domain &     UI & Docs     QA & Security
Adapters
```

### Director 1 — Domain & Adapter Director
**Scope:** `/internal/domain/`, `/internal/adapters/`, infrastructure config.

Does inline:
- Core business model definitions and port interfaces
- Database schema migrations and index design
- External service adapters (REST clients, PubSub, GCS, etc.)
- Docker / Kubernetes manifests and docker-compose
- CI/CD pipeline YAML (GitHub Actions, Cloud Build)

Spawns a sub-agent **only when**:
- A full legacy migration requires diffing 20+ files simultaneously
- Generating a complete SQL migration set for a schema with 10+ tables

### Director 2 — UI & Documentation Director
**Scope:** `/src/components/`, `/src/pages/`, `/src/ui/`, OpenAPI schemas, READMEs.

Does inline:
- Component scaffolding, page layouts, routing wiring
- Mock/seed data generation for early UI development
- OpenAPI/Swagger schema generation from endpoint definitions
- README updates and architecture documentation

Spawns a sub-agent **only when**:
- Full visual regression audit requires headless browser session
- Accessibility audit across 10+ rendered page states simultaneously

### Director 3 — QA & Security Director
**Scope:** Test suites, linting, vulnerability scanning, compliance gates.

Does inline:
- Unit + integration test generation based on coverage gaps
- Dependency vulnerability scanning (`npm audit`, `cargo audit`, `govulncheck`)
- Code smell detection and formatting enforcement
- Stack trace parsing and patch generation on test failures

Spawns a sub-agent **only when**:
- E2E browser test suite requires a persistent headless session
- Security audit spans multiple repos simultaneously

---

## Coordinator Decision Logic

```
INCOMING TASK
     │
     ├─ Is this a domain model / business rule change?
     │       → Director 1
     │
     ├─ Is this a UI component / API doc / data generation task?
     │       → Director 2
     │
     ├─ Is this a test, lint, security, or debug task?
     │       → Director 3
     │
     └─ Does this task cross 2+ Directors?
             → Coordinator handles sequencing.
               Director 1 first (data contract),
               Director 2 second (UI layer),
               Director 3 third (test + sign-off).
```

---

## Verification Gates (Exit Conditions)

The Coordinator CANNOT mark a task complete until ALL of the following pass:

| Gate | Command | Who Runs It |
|------|---------|-------------|
| Hexagonal boundary check | `/hex-validate` → `scripts/hex-validate.sh` | Coordinator |
| Security audit | `/sec-audit` → `scripts/sec-audit.sh` | Director 3 |
| Full build green | `go build / cargo build / npm run build` | Director 1 |
| Test coverage threshold | Defined per-project in `.agents/config.json` | Director 3 |
| UI lint | `/ui-lint` → `scripts/ui-lint.sh` | Director 2 |

If any gate fails, the responsible Director self-heals (up to 10 loops) before
escalating to the Coordinator for human review.

---

## Token Cost Control Rules

- **Never** spawn a sub-agent for a task completable in <500 lines of output.
- **Always** kill sub-agents on task completion — do not keep them idle.
- **Prefer** sequential inline execution over parallel spawning when tasks are
  dependent on each other's output.
- **Use branch isolation** (`workspace: 'branch'`) for Directors when they are
  writing to the same repository simultaneously to prevent merge conflicts.
- **Cache context** for large codebases — read files once, pass via artifacts,
  do not re-read the same file across multiple tool calls.
