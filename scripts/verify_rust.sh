#!/bin/bash
# verify_rust.sh — Run after any .rs file mutation
ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
CARGO_TOMLS=$(find "$ROOT" -name "Cargo.toml" -not -path "*/target/*" 2>/dev/null)

ALL_PASS=true
for toml in $CARGO_TOMLS; do
  dir=$(dirname "$toml")
  echo "🔨 [cargo check] Checking $dir..."
  (cd "$dir" && cargo check 2>&1)
  if [ $? -ne 0 ]; then
    echo "❌ cargo check FAILED in $dir"
    ALL_PASS=false
  fi
done

if [ "$ALL_PASS" = false ]; then
  exit 1
fi
echo "✅ All Rust crates check clean."
exit 0
