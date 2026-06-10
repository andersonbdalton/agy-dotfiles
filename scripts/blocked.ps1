# =============================================================================
# blocked.ps1 — Called by the agent whenever a /goal hits a BLOCKED state.
#
# USAGE:
#   .\scripts\blocked.ps1 `
#     -Goal "GOAL-007" `
#     -Title "Load balancer SSL cert needs manual domain verification" `
#     -Context "gcloud ssl-certificates create requires domain verified. DNS not yet pointing to LB IP." `
#     -Priority 1
#
# SETUP:
#   $env:TODOIST_API_TOKEN = "your_token_here"
#   Get token at: https://todoist.com/app/settings/integrations/developer
#
# PRIORITY SCALE (Todoist):
#   1 = p1 (red, urgent)   — agent is completely stopped, cannot proceed
#   2 = p2 (orange)        — blocked but a workaround exists
#   3 = p3 (blue)          — needs user input but not urgent
#   4 = p4 (normal)        — FYI / decision needed eventually
# =============================================================================

param(
    [Parameter(Mandatory=$true)]  [string]$Goal,
    [Parameter(Mandatory=$true)]  [string]$Title,
    [Parameter(Mandatory=$false)] [string]$Context = "",
    [Parameter(Mandatory=$false)] [int]   $Priority = 1,
    [Parameter(Mandatory=$false)] [string]$Due = "today",
    [Parameter(Mandatory=$false)] [string]$ProjectId = $env:TODOIST_PROJECT_ID
)

# ── Validate token ────────────────────────────────────────────────────────────
$token = $env:TODOIST_API_TOKEN
if (-not $token) {
    Write-Host ""
    Write-Host "❌ TODOIST_API_TOKEN not set." -ForegroundColor Red
    Write-Host ""
    Write-Host "   1. Get your token at: https://todoist.com/app/settings/integrations/developer"
    Write-Host "   2. Set it in PowerShell:"
    Write-Host "      `$env:TODOIST_API_TOKEN = 'your_token_here'"
    Write-Host "   3. Or add it to your .env.local file to persist across sessions"
    Write-Host ""
    exit 1
}

# ── Build content ─────────────────────────────────────────────────────────────
$timestamp  = (Get-Date -Format "yyyy-MM-dd HH:mm") + " UTC"
$taskContent = "🔴 [$Goal] BLOCKED: $Title"

$description = ""
if ($Context) {
    $description = @"
**Context from agent:**

$Context

---
*Auto-created by Antigravity agent — $timestamp*
*Goal: $Goal*
*Resume with: ``/goal continue $Goal``*
"@
}

# ── Build payload ─────────────────────────────────────────────────────────────
$payload = @{
    content     = $taskContent
    description = $description
    priority    = $Priority
    due_string  = $Due
    labels      = @("agent-blocker", "gantry")
}

if ($ProjectId) {
    $payload["project_id"] = $ProjectId
}

$body = $payload | ConvertTo-Json -Depth 5

# ── Post to Todoist API v2 ────────────────────────────────────────────────────
try {
    $response = Invoke-RestMethod `
        -Uri "https://api.todoist.com/rest/v2/tasks" `
        -Method POST `
        -Headers @{ "Authorization" = "Bearer $token"; "Content-Type" = "application/json" } `
        -Body $body

    Write-Host ""
    Write-Host "✅ Todoist task created" -ForegroundColor Green
    Write-Host "   Goal:     $Goal"
    Write-Host "   Blocker:  $Title"
    Write-Host "   Priority: p$Priority"
    Write-Host "   Task ID:  $($response.id)"
    if ($response.url) { Write-Host "   URL:      $($response.url)" }
    Write-Host ""
    Write-Host "⏸️  Agent is BLOCKED. Once resolved, run:" -ForegroundColor Yellow
    Write-Host "   /goal continue $Goal"
    Write-Host ""
}
catch {
    Write-Host ""
    Write-Host "❌ Failed to create Todoist task: $_" -ForegroundColor Red
    Write-Host "   Check your TODOIST_API_TOKEN and network connection."
    Write-Host ""
    Write-Host "   Fallback — manual task description:"
    Write-Host "   [$Goal] BLOCKED: $Title"
    if ($Context) { Write-Host "   Context: $Context" }
    Write-Host ""
    exit 1
}
