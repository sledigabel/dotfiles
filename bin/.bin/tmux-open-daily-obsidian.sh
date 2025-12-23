#!/bin/sh
set -eu

OBSIDIAN_PATH="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/Work/"

# Use helper to ensure session exists, and send keys if it already exists
~/.bin/tmux-ensure-session.sh "_obsidian_daily" "$OBSIDIAN_PATH" 'nvim -c "Obsidian today"' "Escape Escape :w Enter ':Obsidian today' Enter"

# Position cursor at end of file in insert mode
tmux send-keys -t "_obsidian_daily" Escape Escape G i
