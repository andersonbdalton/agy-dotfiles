#!/usr/bin/env bash
# =============================================================================
# blocked.sh — Called by the agent when /goal hits a true blocker.
#
# Pulls TODOIST_API_TOKEN from GCP Secret Manager at runtime.
# No tokens stored locally — ever.
#
# USAGE:
#   ./scripts/blocked.sh \
#     --goal "GOAL-007" \
#     --title "Load balancer SSL cert needs manual domain verification" \
#     --context "gcloud ssl-certificates create completed but cert is PROVISIONING. TXT record needed at Cloudflare for gantryframe.com." \
#     --priority 1
#
# REQUIRES (one-time, done by human):
#   gcloud secrets create gantry-todoist-api-token \
#     --data-file=- --project=ianua-gantry-prod
#   # Paste token, Ctrl+D
#
# PRIORITY SCALE:
#   1 = p1 red    — agent completely stopped
#   2 = p2 orange — partially blocked
#   3 = p3 blue   — needs decision, not urgent
#   4 = p4 normal — FYI
# =============================================================================

set -euo pipefail

GCP_PROJECT="${GCP_PROJECT:-ianua-gantry-prod}"
GOAL=""
TITLE=""
CONTEXT=""
PRIORITY=1
DUE="today"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --goal)     GOAL="$2";     shift 2 ;;
    --title)    TITLE="$2";    shift 2 ;;
    --context)  CONTEXT="$2";  shift 2 ;;
    --priority) PRIORITY="$2"; shift 2 ;;
    --due)      DUE="$2";      shift 2 ;;
    *) echo "Unknown arg: $1"; exit 1 ;;
  esac
done

if [[ -z "$TITLE" ]]; then
  echo "❌ --title is required"
  exit 1
fi

# ── Pull token from Secret Manager ───────────────────────────────────────────
echo "🔐 Fetching Todoist token from Secret Manager..."
TODOIST_API_TOKEN=$(gcloud secrets versions access latest \
  --secret=gantry-todoist-api-token \
  --project="${GCP_PROJECT}" 2>/dev/null) || {
  echo "❌ Could not read secret 'gantry-todoist-api-token' from project '${GCP_PROJECT}'"
  echo "   Create it once with:"
  echo "   gcloud secrets create gantry-todoist-api-token --data-file=- --project=${GCP_PROJECT}"
  exit 1
}

# ── Pull project ID from Secret Manager (optional) ───────────────────────────
TODOIST_PROJECT_ID=$(gcloud secrets versions access latest \
  --secret=gantry-todoist-project-id \
  --project="${GCP_PROJECT}" 2>/dev/null) || TODOIST_PROJECT_ID=""

# ── Build task ────────────────────────────────────────────────────────────────
TASK_CONTENT="🔴 [${GOAL}] BLOCKED: ${TITLE}"
TIMESTAMP=$(date -u +"%Y-%m-%d %H:%M UTC")

DESCRIPTION="**Context from agent:**

${CONTEXT}

---
*Auto-created by Antigravity — ${TIMESTAMP}*
*Goal: ${GOAL}*
*Resume with: \`/goal continue ${GOAL}\`*"

JSON_PAYLOAD=$(python3 -c "
import json
payload = {
    'content':     '${TASK_CONTENT//\'/\\\'}',
    'description': $(echo "$DESCRIPTION" | python3 -c "import json,sys; print(json.dumps(sys.stdin.read().strip()))"),
    'priority':    ${PRIORITY},
    'due_string':  '${DUE}',
    'labels':      ['agent-blocker', 'gantry']
}
if '${TODOIST_PROJECT_ID}':
    payload['project_id'] = '${TODOIST_PROJECT_ID}'
print(json.dumps(payload))
")

# ── Post to Todoist ───────────────────────────────────────────────────────────
RESPONSE=$(curl -sf \
  -X POST \
  -H "Authorization: Bearer ${TODOIST_API_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "$JSON_PAYLOAD" \
  "https://api.todoist.com/rest/v2/tasks")

TASK_ID=$(echo "$RESPONSE" | python3 -c "import json,sys; print(json.load(sys.stdin)['id'])" 2>/dev/null || echo "unknown")

echo ""
echo "✅ Todoist task created (p${PRIORITY})"
echo "   Goal:    ${GOAL}"
echo "   Blocker: ${TITLE}"
echo "   Task ID: ${TASK_ID}"
echo ""
echo "⏸️  Agent BLOCKED. Resolve → /goal continue ${GOAL}"
