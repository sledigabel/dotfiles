#!/bin/bash
set -euo pipefail

PROJECT_LIST=("${HOME}/dev/work" "${HOME}/dev/perso")

# Verify project directories exist
for project in "${PROJECT_LIST[@]}"; do
  if [ ! -d "$project" ]; then
    echo "Error: Project directory does not exist: $project" >&2
    exit 1
  fi
done

# Use fzf to select a project
NEW_SESSION=$(for project in "${PROJECT_LIST[@]}"; do
  ls -d "$project"/* 2>/dev/null
done | fzf --layout=reverse --no-preview)

# Exit if no selection made or fzf cancelled
[ -z "$NEW_SESSION" ] && exit 0

# Validate that the selection is actually a directory
if [ ! -d "$NEW_SESSION" ]; then
  echo "Error: Selected path is not a directory: $NEW_SESSION" >&2
  exit 1
fi

NEW_SESSION_SAFE=$(tr -d '.' <<<"$NEW_SESSION")
SHORT_SESSION=$(basename "$NEW_SESSION_SAFE")

# If session doesn't exist, create it
if ! tmux has-session -t "$SHORT_SESSION" 2>/dev/null; then
  # Create new session in detached mode
  tmux new-session -s "$SHORT_SESSION" -c "$NEW_SESSION" -e "CURRENT_SESSION=${SHORT_SESSION}" -e "TMUX_SESSION_DIR=${NEW_SESSION}" -d 'zsh; ~/.bin/tmux-return-and-cleanup.sh' || {
    echo "Error: Failed to create tmux session '$SHORT_SESSION'" >&2
    exit 1
  }
  
  # Brief wait to ensure session is initialized
  sleep 0.2
  
  # Set environment variables
  tmux set-environment -t "$SHORT_SESSION" CURRENT_SESSION "$SHORT_SESSION" 2>/dev/null || true
  tmux set-environment -t "$SHORT_SESSION" TMUX_SESSION_DIR "$NEW_SESSION" 2>/dev/null || true
fi

# Switch to the session
tmux switch-client -t "$SHORT_SESSION"
