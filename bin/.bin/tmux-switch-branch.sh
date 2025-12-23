#!/bin/bash
set -euo pipefail

# Get the session directory
eval "$(tmux show-environment TMUX_SESSION_DIR)"

# Validate we have a session directory set
if [ -z "$TMUX_SESSION_DIR" ]; then
  echo "Error: TMUX_SESSION_DIR is not set. Are you in a project session?"
  read -p "Press enter to continue"
  exit 1
fi

# Validate we're in a git repository
if ! git -C "$TMUX_SESSION_DIR" rev-parse --git-dir >/dev/null 2>&1; then
  echo "Error: $TMUX_SESSION_DIR is not a git repository"
  read -p "Press enter to continue"
  exit 1
fi

# Get branch selection
branch=""
if [[ "${#}" -eq 1 ]]; then
  branch=$1
elif [[ "${#}" -eq 0 ]]; then
  branch=$(git -C "$TMUX_SESSION_DIR" branch --sort=-committerdate | sed -e 's/^\*/ /' | fzf --layout=reverse --no-preview)
else
  echo "Need 0 or 1 argument"
  read -p "Press enter to continue"
  exit 1
fi

# Exit if no branch selected
if [ -z "$branch" ]; then
  exit 0
fi

# Clean up whitespace from branch name
branch="${branch//[[:blank:]]/}"

# Attempt to checkout the branch
if ! git -C "$TMUX_SESSION_DIR" checkout "$branch" 2>&1; then
  echo "Error: Failed to checkout branch '$branch'"
  echo "This could be due to uncommitted changes or an invalid branch name"
  read -p "Press enter to continue"
  exit 1
fi

echo "Successfully switched to branch: $branch"
read -p "Press enter to continue"
