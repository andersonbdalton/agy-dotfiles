#!/bin/bash
# hex-validate.sh
# Checks that domain layer code does not import infrastructure packages.
# Exit 0 = clean. Exit 1 = boundary violation detected.

echo "🔷 [hex-validate] Running hexagonal boundary check..."

DOMAIN_DIRS=("internal/domain" "internal/core/domain" "src/domain" "lib/domain")
INFRA_IMPORTS=("database/sql" "lib/pq" "cloud.google.com/go" "net/http" "os/exec" "docker" "k8s.io")

VIOLATIONS=0

for dir in "${DOMAIN_DIRS[@]}"; do
  if [ -d "$dir" ]; then
    for pkg in "${INFRA_IMPORTS[@]}"; do
      matches=$(grep -r --include="*.go" --include="*.ts" --include="*.rs" -l "\"$pkg\"" "$dir" 2>/dev/null)
      if [ -n "$matches" ]; then
        echo "❌ BOUNDARY VIOLATION: Domain layer imports infrastructure package '$pkg':"
        echo "$matches"
        VIOLATIONS=$((VIOLATIONS + 1))
      fi
    done
  fi
done

if [ "$VIOLATIONS" -gt 0 ]; then
  echo "❌ [hex-validate] FAILED — $VIOLATIONS boundary violation(s) detected."
  echo "   Fix: Move infrastructure imports to /internal/adapters/ or /internal/infrastructure/."
  exit 1
fi

echo "✅ [hex-validate] PASSED — No hexagonal boundary violations."
exit 0
