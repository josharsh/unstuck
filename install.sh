#!/usr/bin/env bash
set -euo pipefail

SKILL_DIR="$HOME/.claude/skills/unstuck"
SOURCE_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing Unstuck skill..."

mkdir -p "$SKILL_DIR"
cp "$SOURCE_DIR/skills/unstuck/SKILL.md" "$SKILL_DIR/SKILL.md"

echo ""
echo "Unstuck installed successfully!"
echo ""
echo "Usage:"
echo "  /unstuck       — activate loop detection"
echo "  /unstuck reset — clear loop tracking state"
echo ""
echo "Skill is installed at: $SKILL_DIR/SKILL.md"
