#!/bin/bash
# ui-lint.sh
# Runs UI code quality checks: TypeScript type-check, ESLint, and Prettier format check.
# Exit 0 = clean. Exit 1 = lint/format issue detected.

echo "🎨 [ui-lint] Running UI lint checks..."

FAILURES=0

# 1. TypeScript type check
if [ -f "tsconfig.json" ]; then
  echo "🔍 Running TypeScript type check..."
  npx tsc --noEmit 2>&1
  if [ $? -ne 0 ]; then
    echo "❌ TypeScript type errors detected."
    FAILURES=$((FAILURES + 1))
  fi
fi

# 2. ESLint
if [ -f ".eslintrc.js" ] || [ -f ".eslintrc.json" ] || [ -f "eslint.config.js" ] || [ -f "eslint.config.mjs" ]; then
  echo "🔍 Running ESLint..."
  npx eslint . --max-warnings=0 2>&1
  if [ $? -ne 0 ]; then
    echo "❌ ESLint violations detected."
    FAILURES=$((FAILURES + 1))
  fi
fi

# 3. Prettier format check
if [ -f ".prettierrc" ] || [ -f ".prettierrc.json" ] || [ -f "prettier.config.js" ]; then
  echo "🔍 Running Prettier format check..."
  npx prettier --check . 2>&1
  if [ $? -ne 0 ]; then
    echo "❌ Prettier formatting issues detected. Run: npx prettier --write ."
    FAILURES=$((FAILURES + 1))
  fi
fi

if [ "$FAILURES" -gt 0 ]; then
  echo "❌ [ui-lint] FAILED — $FAILURES UI lint issue(s) detected."
  exit 1
fi

echo "✅ [ui-lint] PASSED — All UI lint checks clean."
exit 0
