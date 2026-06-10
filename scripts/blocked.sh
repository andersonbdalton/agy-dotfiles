#!/usr/bin/env bash
# =============================================================================
# blocked.sh — Called by the agent whenever a /goal hits a BLOCKED state.
#
# USAGE:
#   ./scripts/blocked.sh \
#     --goal "GOAL-007" \
#     --title "Load balancer wildcard SSL cert needs manual provisioning" \
#     --context "gcloud compute ssl-certificates create requires domain verification. Domain is registered but DNS not yet pointing to LB IP." \
#     --priority 1
#
# REQUIREMENTS:
#   - TODOIST_API_TOKEN env var (get from todoist.com/app/settings/integrations)
#   - TODOIST_PROJECT_ID env var (optional — defaults to inbox)
#   - curl
#
# PRIORITY SCALE (Todoist):
#   1 = p1 (red, urgent)   — agent is completely stopped
#   2 = p2 (orange)        — blocked but can work around
#   3 = p3 (blue)          — needs input but not urgent
#   4 = p4 (normal)        — FYI
# =============================================================================

set -euo pipefail

# ── Parse arguments ───────────────────────────────────────────────────────────
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

# ── Validate ──────────────────────────────────────────────────────────────────
if [[ -z "${TODOIST_API_TOKEN:-}" ]]; then
  echo "❌ TODOIST_API_TOKEN not set. Add it to your environment."
  echo "   Get your token at: https://todoist.com/app/settings/integrations/developer"
  echo ""
  echo "   PowerShell: \$env:TODOIST_API_TOKEN = 'your_token_here'"
  echo "   Add to .env.local to persist."
  exit 1
fi

if [[ -z "$TITLE" ]]; then
  echo "❌ --title is required"
  exit 1
fi

# ── Build task content ────────────────────────────────────────────────────────
TASK_CONTENT="🔴 [${GOAL}] BLOCKED: ${TITLE}"

DESCRIPTION=""
if [[ -n "$CONTEXT" ]]; then
  DESCRIPTION="**Context from agent:**

${CONTEXT}

---
*Auto-created by Antigravity agent — $(date -u +"%Y-%m-%d %H:%M UTC")*
*Goal: ${GOAL}*
*Resume with: \`/goal continue ${GOAL}\`*"
fi

# ── Build JSON payload ────────────────────────────────────────────────────────
JSON_PAYLOAD=$(cat <<EOF
{
  "content": $(echo "$TASK_CONTENT" | python3 -c "import json,sys; print(json.dumps(sys.stdin.read().strip()))"),
  "description": $(echo "$DESCRIPTION" | python3 -c "import json,sys; print(json.dumps(sys.stdin.read().strip()))"),
  "priority": ${PRIORITY},
  "due_string": "${DUE}",
  "labels": ["agent-blocker", "gantry"]
}
EOF
)

# Add project_id if set
if [[ -n "${TODOIST_PROJECT_ID:-}" ]]; then
  JSON_PAYLOAD=$(echo "$JSON_PAYLOAD" | python3 -c "
import json,sys
d = json.load(sys.stdin)
d['project_id'] = '${TODOIST_PROJECT_ID}'
print(json.dumps(d))
")
fi

# ── Post to Todoist API ───────────────────────────────────────────────────────
RESPONSE=$(curl -sf \
  -X POST \
  -H "Authorization: Bearer ${TODOIST_API_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "$JSON_PAYLOAD" \
  "https://api.todoist.com/rest/v2/tasks")

TASK_ID=$(echo "$RESPONSE" | python3 -c "import json,sys; print(json.load(sys.stdin)['id'])" 2>/dev/null || echo "unknown")
TASK_URL=$(echo "$RESPONSE" | python3 -c "import json,sys; print(json.load(sys.stdin).get('url', ''))" 2>/dev/null || echo "")

echo ""
echo "✅ Todoist task created"
echo "   Goal:     ${GOAL}"
echo "   Blocker:  ${TITLE}"
echo "   Priority: p${PRIORITY}"
echo "   Task ID:  ${TASK_ID}"
[[ -n "$TASK_URL" ]] && echo "   URL:      ${TASK_URL}"
echo ""
echo "⏸️  Agent is now BLOCKED. Resolve the above, then run:"
echo "   /goal continue ${GOAL}"
