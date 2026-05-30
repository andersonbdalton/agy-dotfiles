#!/bin/bash
# verify_ts.sh — Run after any .ts/.tsx file mutation
ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
PKG_JSONS=$(find "$ROOT" -name "tsconfig.json" -not -path "*/node_modules/*" 2>/dev/null)

ALL_PASS=true
for tsconfig in $PKG_JSONS; do
  dir=$(dirname "$tsconfig")
  echo "🔨 [tsc --noEmit] Checking $dir..."
  (cd "$dir" && npx tsc --noEmit 2>&1)
  if [ $? -ne 0 ]; then
    echo "❌ TypeScript type check FAILED in $dir"
    ALL_PASS=false
  fi
done

if [ "$ALL_PASS" = false ]; then
  exit 1
fi
echo "✅ All TypeScript type checks pass."
exit 0
