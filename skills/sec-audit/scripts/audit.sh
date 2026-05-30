#!/bin/bash
echo "🛡️ Running Enterprise Security & Secret Audit..."
if grep -rE "sk_live_|AIzaSy|passwd=|SECRET_KEY=" ./src/ ./internal/; then
    echo "❌ SECURITY VIOLATION: Hardcoded credentials or API keys detected!"
    exit 1
fi
if [ -f "go.mod" ]; then go install golang.org/x/vuln/cmd/govulncheck@latest && govulncheck ./... || exit 1; fi
if [ -f "Cargo.toml" ]; then cargo audit || exit 1; fi
echo "✅ Security posture is clean. Audit passed."
exit 0
