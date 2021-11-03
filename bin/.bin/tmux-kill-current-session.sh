#!/bin/bash -x

[ "${CURRENT_SESSION}" == "" ] && exit 1

tmux switch-client -t 0
tmux run-shell -d 1 -t 0 "tmux kill-session -t ${CURRENT_SESSION}"
