#!/bin/bash
set -euo pipefail

current_session=$(tmux display-message -p '#S')

# Get the previous session to switch to
previous_session=$(~/.bin/tmux-session-tracker.sh get)

# If we have a previous session, switch to it, otherwise switch to session 0
if [ -n "$previous_session" ]; then
    tmux switch-client -t "$previous_session"
else
    tmux switch-client -t 0
fi

# Kill the original session after switching
tmux kill-session -t "$current_session"
