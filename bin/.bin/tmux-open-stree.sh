#!/bin/sh
set -eu

# This opens up stree for the current tmux pane's current working directory
# if the session dir is defined, use this, and if not use the pane's cwd
if [ -n "${TMUX_SESSION_DIR:-}" ]; then
    stree "${TMUX_SESSION_DIR}"
else
    tmux display -p '#{pane_current_path}' | xargs stree
fi 
