#!/bin/bash
echo "?? Initializing Workspace Clean Room..."
if [ -d "node_modules" ]; then rm -f package-lock.json yarn.lock; fi
if [ -f "go.sum" ]; then go clean -cache -modcache; fi
if [ -d "target" ]; then cargo clean; fi
git clean -fdx --exclude=.agents/ --exclude=.gemini/
echo "? Workspace reset to an absolute clean-room state."
exit 0
