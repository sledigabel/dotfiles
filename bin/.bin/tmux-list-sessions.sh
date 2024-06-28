#!/bin/bash

# SESSION=$(tmux list-sessions | awk -F':' '{print $1}' | grep -e -v "^0$" -v "^0" fzf --layout=reverse --no-preview)
SESSION=$(tmux list-sessions | awk -F':' '{print $1}' | grep -E -v "^(0|_.*)$" | fzf --layout=reverse --no-preview)

[ "$SESSION" == "" ] && exit 0
tmux switch-client -t "${SESSION}"
