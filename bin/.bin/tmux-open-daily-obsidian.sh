#!/bin/sh
set -eu

OBSIDIAN_PATH="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/Work/"

# Check if session already exists
if tmux has-session -t "_obsidian_daily" 2>/dev/null; then
	# Session exists - refresh it by opening daily note
	# First escape to normal mode, save, then open daily note, then position cursor
	tmux send-keys -t "_obsidian_daily" Escape Escape :w Enter
	sleep 0.1
	tmux send-keys -t "_obsidian_daily" ':Obsidian today' Enter
	sleep 0.1
	tmux send-keys -t "_obsidian_daily" Escape Escape G i

	# Switch to the session
	if [ -n "${TMUX:-}" ]; then
		tmux switch-client -t "_obsidian_daily"
	else
		tmux attach-session -t "_obsidian_daily"
	fi
else
	# Create new session with daily note open and position cursor at end
	tmux new-session -s "_obsidian_daily" -c "$OBSIDIAN_PATH" -d 'nvim -c "Obsidian today"; ~/.bin/tmux-return-and-cleanup.sh'

	# Wait for session to be fully initialized
	for i in {1..10}; do
		if tmux has-session -t "_obsidian_daily" 2>/dev/null && tmux list-panes -t "_obsidian_daily" >/dev/null 2>&1; then
			break
		fi
		sleep 0.05
	done

	# Position cursor at end of file in insert mode
	tmux send-keys -t "_obsidian_daily" Escape Escape G i

	# Switch to the session
	if [ -n "${TMUX:-}" ]; then
		tmux switch-client -t "_obsidian_daily"
	else
		tmux attach-session -t "_obsidian_daily"
	fi
fi
