#!/bin/sh
set -eu

~/.bin/tmux-ensure-session.sh "_copilot" "$HOME" 'nvim -c "CopilotChatFullScreen"'
