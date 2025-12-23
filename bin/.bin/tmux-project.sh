#!/bin/bash
set -euo pipefail

PROJECT_LIST=("${HOME}/dev/work" "${HOME}/dev/perso")

# Verify project directories exist
for project in "${PROJECT_LIST[@]}"; do
  if [ ! -d "$project" ]; then
    echo "Error: Project directory does not exist: $project"
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
  echo "Error: Selected path is not a directory: $NEW_SESSION"
  exit 1
fi

NEW_SESSION_SAFE=$(tr -d '.' <<<"$NEW_SESSION")
SHORT_SESSION=$(basename "$NEW_SESSION_SAFE")

# Check if session already exists
if tmux has-session -t "$SHORT_SESSION" 2>/dev/null; then
  echo "Session '$SHORT_SESSION' already exists, switching to it..."
  tmux switch-client -t "$SHORT_SESSION"
  exit 0
fi

# Create new session
if ! tmux new-session -s "$SHORT_SESSION" -c "$NEW_SESSION" -e "CURRENT_SESSION=${SHORT_SESSION}" -e "TMUX_SESSION_DIR=${NEW_SESSION}" -d 'zsh; ~/.bin/tmux-return-and-cleanup.sh'; then
  echo "Error: Failed to create tmux session '$SHORT_SESSION'"
  exit 1
fi

tmux set-environment -t "$SHORT_SESSION" CURRENT_SESSION="$SHORT_SESSION"
tmux set-environment -t "$SHORT_SESSION" TMUX_SESSION_DIR="$NEW_SESSION"
tmux switch-client -t "$SHORT_SESSION"
