#!/bin/bash

SESSION=`tmux list-sessions | awk -F':' '{print $1}' | fzf --layout=reverse --no-preview`

[ "${SESSION}" == "" ] && exit 1
tmux switch-client -t ${SESSION}

