---
name: gantry-goal-workflow
description: >
  The definitive workflow for running structured, spec-driven development sessions on any project.
  Use this when starting a new goal, running /goal, using /grill-me for spec alignment, managing
  roadmaps, writing GOAL specs, or when you need to understand how this development process is structured.
  This skill was built from real sessions building the Gantry SaaS platform and encodes the exact
  methodology that was used to ship 10 goals across 6 months of development.
---

# Gantry Goal Workflow — Structured AI Development System

## What This Skill Is

This skill encodes the **complete development methodology** used to build the Gantry insurance risk
intelligence platform — a multi-tenant SaaS product built entirely through structured AI-agent sessions.

It's not theory. Every pattern here was used in production sessions to ship real code.

---

## The Three-Layer System

```
ROADMAP.md          ← The strategic picture (what you're building and why)
    │
    ▼
GOAL-XXX-Spec.md    ← The tactical contract (exactly what this session must deliver)
    │
    ▼
/goal + /grill-me   ← The execution layer (agent runs the goal, interviews you to close gaps)
```

Each layer has one job. Don't mix them.

---

## Layer 1: The Roadmap

**File:** `war-room/[Project]/Roadmap.md`  
**Purpose:** High-altitude view. Goals listed in priority order. No implementation detail.

### Roadmap Format

```markdown
# [Project] Roadmap

## Status: Active Development

## Goals

| Goal | Name | Status | Priority |
|---|---|---|---|
| GOAL-001 | [Name] | ✅ Complete | P0 |
| GOAL-002 | [Name] | 🔄 In Progress | P0 |
| GOAL-003 | [Name] | 📋 Planned | P1 |

## Principles
- [What drives sequencing decisions]
- [What you will NOT build yet]

## Dependencies
- [External blockers or prerequisites]
```

### Roadmap Rules
1. **Every goal has a number** — never rename or renumber completed goals
2. **Status is binary** — either it's done (✅) or it's not (📋/🔄). No "80% complete"
3. **Goals are sequenced** — earlier goals must not depend on later ones
4. **The roadmap is a contract** — don't add goals mid-session. Add them to the backlog section instead

---

## Layer 2: The Goal Spec

**File:** `war-room/[Project]/Goals/GOAL-XXX-Spec.md`  
**Purpose:** The complete technical contract for a single session. An agent reading this file alone should be able to execute the goal with zero ambiguity.

### Spec Format

```markdown
# GOAL-XXX: [Name]

> **Status:** Draft | In Review | Approved | In Progress | Complete  
> **Dependencies:** GOAL-001, GOAL-002 (must be complete before starting)  
> **Estimated Sessions:** 1–3

---

## Problem Statement

[1–3 sentences. What is broken or missing? Why does it matter right now?]

---

## Success Criteria

These are the acceptance tests. The goal is DONE when ALL of these are true:

- [ ] [Specific, testable criterion — e.g. "Backend builds with `go build ./...` returning 0"]
- [ ] [Specific, testable criterion — e.g. "`/health` returns `{"status":"ok","db":"ok"}`"]
- [ ] [Specific, testable criterion]

---

## Out of Scope

Explicitly list what this goal does NOT include. This prevents scope creep mid-session.

- [What you're NOT building]
- [What comes in a later goal]

---

## Technical Specification

### [Component 1]

[Detailed technical spec — exact file paths, function signatures, DB schema, API contracts]

```go
// Example code showing expected interfaces
```

### [Component 2]

[...]

---

## Verification Steps

```bash
# Exact commands to run to verify success
go build ./...
curl https://api.example.com/health
```

---

## Files to Create or Modify

| File | Action | Notes |
|---|---|---|
| `path/to/file.go` | Create | [What it contains] |
| `path/to/existing.ts` | Modify | [What changes] |

---

## Known Risks

- [Risk]: [Mitigation]
```

### Spec Writing Rules
1. **Write the spec before starting the goal** — never start coding first
2. **Success criteria must be testable** — "looks good" is not a criterion
3. **Out of scope section is mandatory** — it stops 80% of scope creep
4. **Technical spec must be specific** — vague specs produce vague code
5. **One spec per goal** — never bundle unrelated work

---

## Layer 3: Execution with /goal and /grill-me

### /goal — The Execution Command

The `/goal` command tells the agent to execute a goal as an autonomous, non-stop operation.

**How to use it:**

```
/goal start GOAL-XXX
```

The agent will:
1. Read the spec from `war-room/[Project]/Goals/GOAL-XXX-Spec.md`
2. Create a progress artifact (`goal_XXX_progress.md`)
3. Execute all tasks in the spec
4. Verify against success criteria
5. Report completion or blockers

**Variants:**
```
/goal start GOAL-XXX       ← Begin a new goal
/goal continue GOAL-XXX    ← Resume an interrupted goal  
/goal verify GOAL-XXX      ← Run only the verification steps
/goal confirm GOAL-XXX     ← Confirm goal complete and update roadmap
```

**The /goal contract:**
- Agent does NOT stop to ask questions unless it hits a true blocker
- Agent does NOT ask for permission for standard operations
- Agent commits and pushes to `main` automatically
- Agent reports `GOAL COMPLETE` or `BLOCKED: [reason]` — nothing in between

### /grill-me — The Alignment Interview

The `/grill-me` command is used BEFORE writing a spec. It interviews you to surface hidden requirements, resolve ambiguities, and lock in decisions before they become bugs.

**How to use it:**

```
/grill-me on GOAL-XXX
/grill-me GOAL-008
```

The agent will:
1. Ask you 5–10 pointed questions about the goal
2. Challenge vague requirements ("what does 'fast' mean exactly?")
3. Surface dependencies you may have missed
4. Identify risks before they're written into code
5. Produce a draft spec based on your answers

**When to use /grill-me:**
- Before writing any new GOAL spec
- When a goal feels unclear or ambiguous
- When you have conflicting ideas about how something should work
- When you're about to start something that touches core infrastructure

**When NOT to use /grill-me:**
- After the spec is written and approved — just `/goal start`
- For small fixes or well-understood tasks
- When you already have a detailed spec

### /grill-me Output → Spec Input

The output of `/grill-me` should feed directly into the GOAL spec:

```
/grill-me on GOAL-008  →  Agent asks 8 questions  →  You answer  →  Agent writes draft spec
                                                                            ↓
                                                         You review and approve spec
                                                                            ↓
                                                              /goal start GOAL-008
```

---

## The Session Structure (How This Actually Works)

A real development session using this workflow looks like this:

```
Session Start
│
├── [If new goal] /grill-me on GOAL-XXX
│   └── 5–10 questions → approved spec → saved to war-room
│
├── /goal start GOAL-XXX
│   ├── Agent reads spec
│   ├── Agent creates progress artifact
│   ├── Agent executes tasks (autonomous, no interruptions)
│   ├── Agent runs verification commands
│   └── Agent reports COMPLETE or BLOCKED
│
├── [If BLOCKED] User resolves blocker → /goal continue GOAL-XXX
│
├── /goal confirm GOAL-XXX
│   └── Progress artifact updated, roadmap updated
│
└── [If time remains] /grill-me on GOAL-[X+1]
    └── Prep next goal for next session
```

---

## Progress Artifacts

Every running goal has a progress artifact that the agent maintains throughout execution:

**File:** `brain/[conversation-id]/goal_XXX_progress.md`  
**Purpose:** Single source of truth for what's done, what's in progress, what's blocked

### Progress Artifact Format

```markdown
# GOAL-XXX Progress

> Commit trail: `abc123` → `def456`

## ✅ COMPLETED
- [Task that is done, with commit reference]

## 🔄 IN PROGRESS  
- [Task currently being worked on]

## ⏳ PENDING
- [Task not started yet]

## ❌ BLOCKED
- [Blocker description and what's needed to unblock]

## Verification Status
| Criterion | Status | Notes |
|---|---|---|
| Backend builds | ✅ | `go build ./...` passes |
| /health returns ok | ⏳ | Not yet tested |
```

---

## Installed Skills (This Machine)

The following skills are currently installed at `C:\Users\dalt\.agents\skills\`:

| Skill | Trigger | Purpose |
|---|---|---|
| `unrestricted-architect` | Always active | Enforces modular architecture, auto-corrects build failures (up to 10x) |
| `find-skills` | "find a skill for..." | Discovers and installs skills from the skills ecosystem |
| `google-agents-cli-adk-code` | "write agent code", "ADK tool" | Google ADK Python patterns — tools, callbacks, orchestration |
| `google-agents-cli-deploy` | "deploy an agent", "Cloud Run" | ADK deployment — Agent Runtime, Cloud Run, GKE |
| `google-agents-cli-eval` | "evaluate my agent", "evalset" | ADK evaluation — metrics, evalsets, LLM-as-judge |
| `google-agents-cli-observability` | "set up tracing", "monitor agent" | Cloud Trace, BigQuery analytics, third-party integrations |
| `google-agents-cli-publish` | "publish agent", "Gemini Enterprise" | Agent publishing and registration |
| `google-agents-cli-scaffold` | "create agent project", "new ADK project" | ADK scaffolding — `scaffold create`, `enhance`, `upgrade` |
| `google-agents-cli-workflow` | "develop an agent", "build with ADK" | Full ADK lifecycle — scaffold → build → eval → deploy → observe |
| `hex-validate` | `/hex-validate` | Validates hexagonal architecture boundaries |
| `sec-audit` | `/sec-audit` | Security audit — secrets scanning, CVE check |
| `ui-lint` | `/ui-lint` | TypeScript + ESLint + Prettier validation |
| `gantry-goal-workflow` | `/goal`, `/grill-me`, "write spec" | **This skill** — structured goal-driven development |

---

## Skill Installation

To install this skill on a new machine:

```bash
# Via npx skills (if available)
npx skills add daltna/agy-dotfiles@gantry-goal-workflow -g -y

# Or manually — clone the dotfiles and copy the skill
git clone https://github.com/daltna/agy-dotfiles.git
cp -r agy-dotfiles/skills/gantry-goal-workflow ~/.agents/skills/
```

---

## Real Example: How Gantry Was Built

The Gantry platform (github.com/daltna/gantry) was built using exactly this workflow:

| Goal | /grill-me questions | Key decisions made | Shipped |
|---|---|---|---|
| GOAL-002 | "Which auth method?" "Password fallback?" "JWT or session?" | WebAuthn passkeys only. No passwords ever. JWT in HttpOnly cookie. 1hr idle / 7-day absolute. | Passkey auth, per-tenant WebAuthn registry, RLS on all tables |
| GOAL-003 | "What's the submission lifecycle?" "Who can see cross-tenant?" | 8-stage pipeline. Zero-copy grant model via `submission_grants`. | Full pipeline — submissions, documents, tasks, carriers |
| GOAL-007 | "What's the public URL structure?" "How do tenants map to subdomains?" | `*.gantryframe.com` wildcard. Custom domains for JanAxis + Archolex. | Load balancer, SSL, URL map |
| GOAL-008 | "What analytics do you actually need?" "Mapbox scope?" | Server-side token vending for Mapbox. GCS upload with signed URLs. | Analytics, Mapbox, document upload |
| GOAL-009 | "What's the homepage value prop?" "Mention House of Ianua?" | "Uncertainty costs money." Powered by Altus Foundry. No House of Ianua. Invite-only. | Full SaaS homepage + 12-tenant portal system |

Each goal took 1–2 sessions. `/grill-me` prevented at least 3 major architectural mistakes per goal.

---

## Anti-Patterns (What NOT to Do)

| Anti-Pattern | Why It's Bad | Correct Approach |
|---|---|---|
| Start coding without a spec | No contract = no done | Always write spec first |
| Write a vague spec | "Auth system" is not a spec | Every success criterion must be testable |
| Ask /goal to stop and check in | Breaks autonomous execution | Let it run, review the progress artifact |
| Bundle 3 goals into one | Creates untestable success criteria | One goal = one spec = one set of criteria |
| Skip /grill-me for complex goals | Hidden assumptions become bugs | Always /grill-me before infrastructure work |
| Let the spec drift during execution | Spec is the contract | If requirements change, write a new goal |
| No out-of-scope section | Scope creep guaranteed | Always explicitly list what's NOT in scope |

---

## Files to Keep in War Room

For any project using this workflow, maintain these files:

```
war-room/[Project]/
├── Roadmap.md                    ← Goal sequence + status
├── Architecture.md               ← System design decisions (updated after each goal)
├── Goals/
│   ├── GOAL-001-Spec.md
│   ├── GOAL-002-Spec.md
│   └── ...
└── Sessions/
    ├── YYYY-MM-DD.md             ← What happened in each session
    └── ...
```

The `Sessions/` directory is optional but valuable — a 2-sentence summary per session makes it easy to re-orient after any gap.

---

## Todoist Blocker Integration

When a `/goal` run hits a **true blocker** — something the agent cannot resolve autonomously — it
creates a Todoist task assigned to you so it appears in your Todoist inbox immediately.

**"True blocker" means:**
- Manual credential action required (e.g. OAuth, 2FA, domain verification)
- GCP IAM permission that needs a human to grant
- External dependency not yet available (e.g. DNS not propagated, API not yet provisioned)
- A decision with business implications that the agent cannot make
- A secret/API key that doesn't exist yet and needs to be created

**NOT a blocker (agent fixes these itself):**
- Build errors → agent self-corrects up to 10 iterations
- Type errors → agent reads the error and fixes it
- Missing npm package → agent installs it
- File doesn't exist → agent creates it

### Setup (One Time — Human Action Required)

**Step 1 — Get your Todoist API token:**
1. Open Todoist → Settings → Integrations → Developer
2. Copy your personal API token

**Step 2 — Store in GCP Secret Manager:**
```powershell
# Create the secret (paste token when prompted, then Ctrl+Z + Enter on Windows)
gcloud secrets create gantry-todoist-api-token `
  --data-file=- --project=ianua-gantry-prod

# Optional — scope agent tasks to a specific Todoist project
# Get project ID from URL: todoist.com/app/project/2350XXXXXX
gcloud secrets create gantry-todoist-project-id `
  --data-file=- --project=ianua-gantry-prod
```

That's it. No tokens on disk. No env vars. The agent pulls the token from Secret Manager
at runtime every time it needs to create a blocker task.

**Verify it's stored:**
```powershell
gcloud secrets versions access latest --secret=gantry-todoist-api-token --project=ianua-gantry-prod
```

### How the Agent Creates Tasks

When blocked, the agent runs:
```powershell
# Windows
.\scripts\blocked.ps1 `
  -Goal "GOAL-007" `
  -Title "SSL certificate requires manual domain verification" `
  -Context "gcloud compute ssl-certificates create completed but cert is in PROVISIONING state. Domain TXT record must be added at registrar. Registrar: Cloudflare. Zone: gantryframe.com" `
  -Priority 1
```

This creates a Todoist task that looks like:

```
🔴 [GOAL-007] BLOCKED: SSL certificate requires manual domain verification

Context from agent:
gcloud compute ssl-certificates create completed but cert is in PROVISIONING
state. Domain TXT record must be added at registrar.
Registrar: Cloudflare. Zone: gantryframe.com

---
Auto-created by Antigravity agent — 2026-06-10 14:30 UTC
Goal: GOAL-007
Resume with: `/goal continue GOAL-007`
```

### Priority Scale

| Priority | Todoist Color | When to Use |
|---|---|---|
| `1` | 🔴 Red (p1, urgent) | Agent is completely stopped — cannot proceed at all |
| `2` | 🟠 Orange (p2) | Blocked on one path but can partially continue |
| `3` | 🔵 Blue (p3) | Needs a decision but not time-critical |
| `4` | ⚪ Normal (p4) | FYI / something to review when you have time |

### Labels Applied Automatically

Every agent-created task gets these labels:
- `agent-blocker` — filter to see all open agent blockers
- `gantry` — or whatever project prefix is relevant

**Todoist filter to see all open blockers:**
```
label:agent-blocker & !completed
```

### The Resolution Loop

```
Agent hits blocker
    │
    ▼
blocked.ps1 runs → Todoist task created → appears on your phone/desktop
    │
    ▼
You see it in Todoist
    │
    ▼
You resolve it (grant IAM, add DNS record, create secret, etc.)
    │
    ▼
Check the task in Todoist
    │
    ▼
Return to Antigravity and run:
    /goal continue GOAL-XXX
    │
    ▼
Agent resumes where it stopped
```

### Todoist Task Checklist (For You to Fill In)

When you receive an agent-blocker task, the resolution steps are always one of:

| Blocker Type | What to Do |
|---|---|
| GCP IAM permission | `gcloud projects add-iam-policy-binding ... --role=...` |
| Secret doesn't exist | `gcloud secrets create ... --data-file=-` |
| DNS record needed | Add TXT/CNAME at your registrar (Cloudflare, etc.) |
| OAuth/2FA required | Log in manually and re-run `gcloud auth login` |
| API not enabled | `gcloud services enable [api].googleapis.com` |
| Decision needed | Make the call, update the spec, `/goal continue` |
| External dep not ready | Wait, then `/goal continue` when it's live |

---

## Files to Keep in War Room

For any project using this workflow, maintain these files:

```
war-room/[Project]/
├── Roadmap.md                    ← Goal sequence + status
├── Architecture.md               ← System design decisions (updated after each goal)
├── Goals/
│   ├── GOAL-001-Spec.md
│   ├── GOAL-002-Spec.md
│   └── ...
└── Sessions/
    ├── YYYY-MM-DD.md             ← What happened in each session
    └── ...
```

The `Sessions/` directory is optional but valuable — a 2-sentence summary per session makes it easy to re-orient after any gap.
