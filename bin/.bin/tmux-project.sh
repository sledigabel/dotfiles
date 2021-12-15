#!/bin/bash

PROJECT_LIST=("${HOME}/dev/work" "${HOME}/dev/perso")

NEW_SESSION=`for project in ${PROJECT_LIST[@]}
do
  ls -d ${project}/*
done | fzf --layout=reverse --no-preview` 

[ "${NEW_SESSION}" == "" ] && exit 1

SHORT_SESSION=$(basename ${NEW_SESSION})

tmux new-session -s "${SHORT_SESSION}" -c "${NEW_SESSION}" -d -e "CURRENT_SESSION=${SHORT_SESSION}" -e "TMUX_SESSION_DIR=${NEW_SESSION}"
tmux switch-client -t ${SHORT_SESSION}

