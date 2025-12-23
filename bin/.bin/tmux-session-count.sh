#!/bin/bash
set -euo pipefail

# Count total number of tmux sessions
SESSION_COUNT=$(tmux list-sessions 2>/dev/null | wc -l | tr -d ' ')

# Output in [N] format
echo "[${SESSION_COUNT}]"
