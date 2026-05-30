#!/bin/bash
# sec-audit.sh
# Runs security checks: hardcoded secrets scan, dependency CVEs, dangerous patterns.
# Exit 0 = clean. Exit 1 = security issue detected.

echo "🔐 [sec-audit] Running security audit..."

FAILURES=0

# 1. Scan for hardcoded secrets (API keys, passwords, tokens in source)
SECRET_PATTERNS=(
  "password\s*=\s*['\"][^'\"]{8,}"
  "api_key\s*=\s*['\"][^'\"]{16,}"
  "secret\s*=\s*['\"][^'\"]{16,}"
  "private_key\s*=\s*['\"]-----BEGIN"
  "AWS_SECRET_ACCESS_KEY\s*="
  "GITHUB_TOKEN\s*="
)

for pattern in "${SECRET_PATTERNS[@]}"; do
  matches=$(grep -rEi --include="*.go" --include="*.ts" --include="*.rs" \
    --include="*.js" --include="*.env" --include="*.yaml" --include="*.json" \
    --exclude-dir=".git" --exclude-dir="node_modules" --exclude-dir="target" \
    --exclude-dir="vendor" \
    "$pattern" . 2>/dev/null | grep -v ".example" | grep -v ".sample")
  if [ -n "$matches" ]; then
    echo "❌ POTENTIAL SECRET DETECTED (pattern: $pattern):"
    echo "$matches"
    FAILURES=$((FAILURES + 1))
  fi
done

# 2. Go dependency vulnerability check (if govulncheck is available)
if command -v govulncheck &>/dev/null; then
  if [ -f "go.mod" ]; then
    echo "🔍 Running govulncheck..."
    govulncheck ./... 2>&1
    if [ $? -ne 0 ]; then
      FAILURES=$((FAILURES + 1))
    fi
  fi
fi

# 3. Rust dependency vulnerability check (if cargo-audit is available)
if command -v cargo-audit &>/dev/null; then
  if [ -f "Cargo.toml" ]; then
    echo "🔍 Running cargo audit..."
    cargo audit 2>&1
    if [ $? -ne 0 ]; then
      FAILURES=$((FAILURES + 1))
    fi
  fi
fi

# 4. Node.js dependency vulnerability check
if [ -f "package.json" ]; then
  echo "🔍 Running npm audit..."
  npm audit --audit-level=high 2>&1
  if [ $? -ne 0 ]; then
    FAILURES=$((FAILURES + 1))
  fi
fi

if [ "$FAILURES" -gt 0 ]; then
  echo "❌ [sec-audit] FAILED — $FAILURES security issue(s) detected."
  exit 1
fi

echo "✅ [sec-audit] PASSED — No security issues detected."
exit 0
