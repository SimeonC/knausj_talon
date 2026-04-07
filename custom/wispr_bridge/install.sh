#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Building wispr-flow-bridge..."
swiftc "$DIR/main.swift" -o "$DIR/wispr-flow-bridge"
ls -lh "$DIR/wispr-flow-bridge"
echo "Built: $DIR/wispr-flow-bridge"
echo ""
echo "Next steps:"
echo "  1. System Settings → Privacy & Security → Accessibility → add $DIR/wispr-flow-bridge"
echo "  2. Input Monitoring → same (if macOS prompts)"
echo "  3. Restart Talon"
