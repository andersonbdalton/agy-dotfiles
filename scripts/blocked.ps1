# =============================================================================
# blocked.ps1 — Called by the agent when /goal hits a true blocker.
#
# Pulls TODOIST_API_TOKEN from GCP Secret Manager at runtime.
# No tokens stored locally — ever.
#
# USAGE:
#   .\scripts\blocked.ps1 `
#     -Goal "GOAL-007" `
#     -Title "Load balancer SSL cert needs manual domain verification" `
#     -Context "gcloud ssl-certificates create completed but cert is PROVISIONING. TXT record needed at Cloudflare for gantryframe.com." `
#     -Priority 1
#
# REQUIRES (one-time, done by human):
#   gcloud secrets create gantry-todoist-api-token `
#     --data-file=- --project=ianua-gantry-prod
#   # paste token, then Ctrl+Z Enter on Windows
#
# PRIORITY SCALE:
#   1 = p1 red    — agent completely stopped
#   2 = p2 orange — partially blocked
#   3 = p3 blue   — needs decision, not urgent
#   4 = p4 normal — FYI
# =============================================================================

param(
    [Parameter(Mandatory=$true)]  [string]$Goal,
    [Parameter(Mandatory=$true)]  [string]$Title,
    [Parameter(Mandatory=$false)] [string]$Context  = "",
    [Parameter(Mandatory=$false)] [int]   $Priority = 1,
    [Parameter(Mandatory=$false)] [string]$Due      = "today",
    [Parameter(Mandatory=$false)] [string]$Project  = "ianua-gantry-prod"
)

# ── Pull token from Secret Manager ───────────────────────────────────────────
Write-Host "🔐 Fetching Todoist token from Secret Manager..." -ForegroundColor Cyan

try {
    $token = gcloud secrets versions access latest `
        --secret=gantry-todoist-api-token `
        --project=$Project 2>$null

    if (-not $token) { throw "Empty result" }
}
catch {
    Write-Host ""
    Write-Host "❌ Could not read 'gantry-todoist-api-token' from Secret Manager." -ForegroundColor Red
    Write-Host ""
    Write-Host "   Create it once with:"
    Write-Host "   gcloud secrets create gantry-todoist-api-token --data-file=- --project=$Project"
    Write-Host "   (paste your Todoist API token, then Ctrl+Z + Enter)"
    Write-Host ""
    Write-Host "   Get your token at: https://todoist.com/app/settings/integrations/developer"
    Write-Host ""
    exit 1
}

# ── Pull project ID from Secret Manager (optional) ───────────────────────────
$projectId = $null
try {
    $projectId = gcloud secrets versions access latest `
        --secret=gantry-todoist-project-id `
        --project=$Project 2>$null
} catch { $projectId = $null }

# ── Build task ────────────────────────────────────────────────────────────────
$timestamp   = (Get-Date -Format "yyyy-MM-dd HH:mm") + " UTC"
$taskContent = "🔴 [$Goal] BLOCKED: $Title"
$description = ""

if ($Context) {
    $description = @"
**Context from agent:**

$Context

---
*Auto-created by Antigravity — $timestamp*
*Goal: $Goal*
*Resume with: ``/goal continue $Goal``*
"@
}

$payload = @{
    content    = $taskContent
    description = $description
    priority   = $Priority
    due_string = $Due
    labels     = @("agent-blocker", "gantry")
}
if ($projectId) { $payload["project_id"] = $projectId }

$body = $payload | ConvertTo-Json -Depth 5

# ── Post to Todoist API v2 ────────────────────────────────────────────────────
try {
    $response = Invoke-RestMethod `
        -Uri "https://api.todoist.com/rest/v2/tasks" `
        -Method POST `
        -Headers @{ "Authorization" = "Bearer $token"; "Content-Type" = "application/json" } `
        -Body $body

    Write-Host ""
    Write-Host "✅ Todoist task created (p$Priority)" -ForegroundColor Green
    Write-Host "   Goal:    $Goal"
    Write-Host "   Blocker: $Title"
    Write-Host "   Task ID: $($response.id)"
    Write-Host ""
    Write-Host "⏸️  Agent BLOCKED. Resolve → /goal continue $Goal" -ForegroundColor Yellow
    Write-Host ""
}
catch {
    Write-Host ""
    Write-Host "❌ Todoist API call failed: $_" -ForegroundColor Red
    Write-Host "   Verify the token in Secret Manager is valid."
    Write-Host ""
    Write-Host "   Manual fallback:"
    Write-Host "   [$Goal] BLOCKED: $Title"
    if ($Context) { Write-Host "   $Context" }
    exit 1
}
