#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
COMMANDS_DIR="$CLAUDE_DIR/commands"

COMMANDS=(
  scaffold onboard plan review migrate debug refactor
  test deploy doc api component secure deps perf
)

echo "Claude Architect — Installing..."

# Back up existing global CLAUDE.md
if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
  cp "$CLAUDE_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md.bak"
  echo "  Backed up existing CLAUDE.md → CLAUDE.md.bak"
fi

# Copy global defaults
cp "$SCRIPT_DIR/global-CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
echo "  Installed global-CLAUDE.md → ~/.claude/CLAUDE.md"

# Create commands directory
mkdir -p "$COMMANDS_DIR"

# Copy command files
for cmd in "${COMMANDS[@]}"; do
  cp "$SCRIPT_DIR/$cmd.md" "$COMMANDS_DIR/$cmd.md"
done
echo "  Installed ${#COMMANDS[@]} commands → ~/.claude/commands/"

# Copy framework knowledge base
cp -r "$SCRIPT_DIR/frameworks/" "$COMMANDS_DIR/frameworks/"
echo "  Installed frameworks → ~/.claude/commands/frameworks/"

echo ""
echo "Done. Run 'claude' and type any command:"
printf "  /%s" "${COMMANDS[@]}"
echo ""
