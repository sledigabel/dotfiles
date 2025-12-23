#!/bin/bash
set -euo pipefail

~/.bin/tmux-ensure-session.sh "_mshell_proxy" "$HOME" "mshell-proxy-wrapper.sh"
