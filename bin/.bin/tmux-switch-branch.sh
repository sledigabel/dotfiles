#!/bin/bash

eval "$(tmux show-environment TMUX_SESSION_DIR)"
[ "$TMUX_SESSION_DIR" = "" ] && exit 1
branch=""
if [[ "${#}" -eq 1 ]]; then
	branch=$1
elif [[ "${#}" -eq 0 ]]; then
	branch=$(git branch --sort=-committerdate | sed -e 's/^\*/ /' | fzf --layout=reverse --no-preview)
else
	echo "Need 0 or 1 argument"
	exit 1
fi

git checkout "${branch//[[:blank:]]/}"
