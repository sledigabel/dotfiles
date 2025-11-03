#!/bin/sh

OBSIDIAN_SESSION="_obsidian_daily"

# does the session exist already?
# if yes send keys to save the current vim buffer.and
# open today's obsidian note
tmux has-session -t "$OBSIDIAN_SESSION" &&
  tmux send-keys -t "${OBSIDIAN_SESSION}.0" Escape Escape :w Enter ":Obsidian today" Enter

# if not, we'll open a new session and pull out today's notes

OBSIDIAN_PATH="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/Work/"
tmux has-session -t "$OBSIDIAN_SESSION" ||
  tmux new-session -s "$OBSIDIAN_SESSION" -c "$OBSIDIAN_PATH" -d 'nvim -c "Obsidian today"; tmux switch-client -t 0'

tmux send-keys -t "$OBSIDIAN_SESSION" Escape Escape G i
tmux switch-client -t "$OBSIDIAN_SESSION"
