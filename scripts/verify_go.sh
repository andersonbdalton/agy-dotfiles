#!/bin/bash
# verify_go.sh — Run after any .go file mutation
# Finds the nearest go.mod and runs go build from there
ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
GO_MODS=$(find "$ROOT" -name "go.mod" -not -path "*/vendor/*" 2>/dev/null)

ALL_PASS=true
for modfile in $GO_MODS; do
  dir=$(dirname "$modfile")
  echo "🔨 [go build] Checking $dir..."
  (cd "$dir" && go build ./... 2>&1)
  if [ $? -ne 0 ]; then
    echo "❌ go build FAILED in $dir"
    ALL_PASS=false
  fi
done

if [ "$ALL_PASS" = false ]; then
  exit 1
fi
echo "✅ All Go modules compile clean."
exit 0
