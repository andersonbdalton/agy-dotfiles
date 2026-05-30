#!/bin/bash
echo "🔍 Running Hexagonal Boundary Analysis..."
if grep -rE "gorm.io|github.com/lib/pq|gin-gonic" ./internal/domain/; then
    echo "❌ ARCHITECTURAL VIOLATION: Core domain logic cannot import infrastructure drivers!"
    exit 1
fi
echo "✅ Architecture is pure. Bound checks passed cleanly."
exit 0
