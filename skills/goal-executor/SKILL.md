---
name: goal-executor
description: >
  The /goal prompt template for Antigravity. Use this when triggering a long-running,
  end-to-end feature implementation. Fill in the bracketed fields before invoking.
  Activates the lean 3-Director swarm from unrestricted-architect.
---

# /goal — End-to-End Feature Executor

## Usage

Fill in ALL bracketed fields before invoking with `/goal`.

```
/goal Execute the complete end-to-end implementation of [FEATURE NAME].

[1. OBJECTIVE]
Build: [One sentence: what does this feature do for the user?]
Target repo/module: [e.g., janaxis/backend, altus_foundry/gateway]
Entry point files: [e.g., internal/adapters/handlers/http.go, src/pages/api/v1/]
Acceptance criteria: [Bullet list of what "done" looks like — be specific]

[2. ARCHITECTURAL CONSTRAINTS]
- Enforce strict Hexagonal boundaries (see unrestricted-architect skill).
- Data layer: [e.g., Cloud SQL PostgreSQL via lib/pq, GCS fallback]
- Auth layer: [e.g., JWT, Google OAuth, or none for internal service]
- Frontend framework: [e.g., Astro + Svelte, Next.js, none]

[3. EXECUTION RULES]
- Use the lean 3-Director topology from unrestricted-architect.
- Compile after every file mutation. Do not advance on a red build.
- Sub-agents: spawn ON-DEMAND only. Kill immediately on task completion.
- Self-healing: up to 10 retry loops on non-zero exits before halting.
- Token budget awareness: prefer inline execution over parallel spawning
  when tasks are sequential or dependent.

[4. VERIFICATION EXIT CONDITIONS]
Do not mark /goal complete until ALL of these pass:
- [ ] /hex-validate passes (no domain layer importing infrastructure)
- [ ] /sec-audit passes (no CVEs in direct dependencies, no hardcoded secrets)
- [ ] Full build is green (go build / cargo build / npm run build)
- [ ] All existing tests still pass (no regressions)
- [ ] New tests cover the new code paths (minimum: happy path + one error case)
- [ ] /ui-lint passes if any frontend was modified
```

---

## Director Routing Reference

| Task Type | Assign To |
|-----------|-----------|
| Domain models, ports, interfaces | Director 1 |
| DB migrations, infra adapters, Docker, CI/CD | Director 1 |
| UI components, pages, mock data, OpenAPI docs | Director 2 |
| Unit/integration tests, lint, security scan, debugging | Director 3 |
| Cross-cutting task spanning 2+ Directors | Coordinator sequences: D1 → D2 → D3 |

## When to Spawn a Sub-Agent vs. Work Inline

```
Need to write or edit <20 files?         → Work INLINE (no sub-agent)
Need to run a headless browser session?  → Spawn Director 2 sub-agent
Need to diff/migrate 20+ legacy files?   → Spawn Director 1 sub-agent
Need parallel E2E + security audit?      → Spawn Director 3 sub-agent
Everything else?                         → INLINE
```
