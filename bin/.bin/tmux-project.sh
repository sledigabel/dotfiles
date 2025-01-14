#!/bin/bash

PROJECT_LIST=("${HOME}/dev/work" "${HOME}/dev/perso")

NEW_SESSION=$(for project in "${PROJECT_LIST[@]}"; do
  ls -d "$project"/*
done | fzf --layout=reverse --no-preview)

NEW_SESSION_SAFE=$(tr -d '.' <<<"$NEW_SESSION")

[ "$NEW_SESSION" == "" ] && exit 1

SHORT_SESSION=$(basename "$NEW_SESSION_SAFE")

tmux new-session -s "$SHORT_SESSION" -c "$NEW_SESSION" -e "CURRENT_SESSION=${SHORT_SESSION}" -e "TMUX_SESSION_DIR=${NEW_SESSION}" -d 'zsh; tmux switch-client -t 0'
tmux set-environment -t "$SHORT_SESSION" CURRENT_SESSION="$SHORT_SESSION"
tmux set-environment -t "$SHORT_SESSION" TMUX_SESSION_DIR="$NEW_SESSION"
tmux switch-client -t "$SHORT_SESSION"
