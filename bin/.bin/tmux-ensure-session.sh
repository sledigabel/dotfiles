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
fi

# Switch to the session
tmux switch-client -t "$SESSION_NAME"
