#!/bin/bash

TMUX_SESSION_NAME="_mshell_proxy"
# check if the session is already active
tmux list-sessions | grep "$TMUX_SESSION_NAME" >/dev/null
if [ "$?" == "0" ]; then
	tmux switch-client -t "$TMUX_SESSION_NAME"
else
	tmux new -s "$TMUX_SESSION_NAME" -e CURRENT_SESSION="$TMUX_SESSION_NAME" -d "mshell-proxy-wrapper.sh; ~/.bin/tmux-return-and-cleanup.sh"
	tmux switch-client -t "$TMUX_SESSION_NAME"
fi
