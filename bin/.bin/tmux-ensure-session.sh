#!/bin/bash
set -euo pipefail

# Helper script to ensure a tmux session exists and switch to it
# Usage: tmux-ensure-session.sh SESSION_NAME WORKING_DIR COMMAND [SEND_KEYS]
#
# Arguments:
#   SESSION_NAME - Name of the tmux session
#   WORKING_DIR  - Working directory for the session
#   COMMAND      - Command to run in the session (will append cleanup handler)
#   SEND_KEYS    - Optional: keys to send if session already exists

if [ "$#" -lt 3 ] || [ "$#" -gt 4 ]; then
  echo "Usage: $0 SESSION_NAME WORKING_DIR COMMAND [SEND_KEYS]"
  exit 1
fi

SESSION_NAME="$1"
WORKING_DIR="$2"
COMMAND="$3"
SEND_KEYS="${4:-}"

# Check if session already exists
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
  # Session exists
  if [ -n "$SEND_KEYS" ]; then
    # Send keys to existing session
    # shellcheck disable=SC2086
    tmux send-keys -t "${SESSION_NAME}.0" $SEND_KEYS
  fi
else
  # Create new session
  tmux new-session -s "$SESSION_NAME" -c "$WORKING_DIR" -d "$COMMAND; ~/.bin/tmux-return-and-cleanup.sh"
  
  # Wait for session to be fully initialized (with timeout)
  for i in {1..10}; do
    if tmux has-session -t "$SESSION_NAME" 2>/dev/null && tmux list-panes -t "$SESSION_NAME" >/dev/null 2>&1; then
      break
    fi
    sleep 0.05
  done
fi

# Switch to the session (use switch-client if inside tmux, attach if outside)
if [ -n "${TMUX:-}" ]; then
  tmux switch-client -t "$SESSION_NAME"
else
  tmux attach-session -t "$SESSION_NAME"
fi
