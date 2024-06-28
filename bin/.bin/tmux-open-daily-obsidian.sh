#!/bin/sh

OBSIDIAN_SESSION="_obsidian_daily"

# does the session exist already?
# if yes send keys to save the current vim buffer.and
# open today's obsidian note
tmux has-session -t "$OBSIDIAN_SESSION" &&
	tmux send-keys -t "${OBSIDIAN_SESSION}.0" Escape Escape :w Enter :ObsidianToday Enter

# if not, we'll open a new session and pull out today's notes
tmux has-session -t "$OBSIDIAN_SESSION" ||
	tmux new-session -s "$OBSIDIAN_SESSION" -c "$HOME" -d 'nvim -c "ObsidianToday"; tmux switch-client -t 0'

tmux switch-client -t "$OBSIDIAN_SESSION"
# tmux send-keys -t "$OBSIDIAN_SESSION" Escape Escape Gi
