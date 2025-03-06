#!/bin/sh

COPILOT_SESSION="_copilot"

# if not, we'll open a new session and pull out today's notes
tmux has-session -t "$COPILOT_SESSION" ||
  tmux new-session -s "$COPILOT_SESSION" -c "$HOME" -d 'nvim -c "CopilotChatFullScreen"; tmux switch-client -t 0'

tmux switch-client -t "$COPILOT_SESSION"
