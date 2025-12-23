#!/bin/bash
set -euo pipefail
# Maintains a global history of ACTIVE session switches

# Use a single shared history file for all processes
HISTORY_FILE="${TMPDIR:-/tmp}/tmux-session-history-$(id -u)"

# Clean history of dead sessions
clean_history() {
    if [ -f "$HISTORY_FILE" ]; then
        local temp_file="${HISTORY_FILE}.tmp"
        true > "$temp_file"
        
        while IFS= read -r session; do
            # Only keep sessions that still exist
            if tmux has-session -t "$session" 2>/dev/null; then
                echo "$session" >> "$temp_file"
            fi
        done < "$HISTORY_FILE"
        
        mv "$temp_file" "$HISTORY_FILE"
    fi
}

# Push current session to history when switching
push_session() {
    local current
    current=$(tmux display-message -p '#S')
    
    # Clean dead sessions first
    clean_history
    
    echo "$current" >> "$HISTORY_FILE"
    # Keep only last 10 sessions
    tail -10 "$HISTORY_FILE" > "${HISTORY_FILE}.tmp"
    mv "${HISTORY_FILE}.tmp" "$HISTORY_FILE"
}

# Get previous session (excluding current, only alive sessions)
get_previous_session() {
    local current
    current=$(tmux display-message -p '#S')
    
    # Clean dead sessions first
    clean_history
    
    # Get last session that isn't the current one and still exists
    if [ -f "$HISTORY_FILE" ]; then
        tac "$HISTORY_FILE" | while IFS= read -r session; do
            if [ "$session" != "$current" ] && tmux has-session -t "$session" 2>/dev/null; then
                echo "$session"
                return 0
            fi
        done
    fi
}

# Return to previous session
return_to_previous() {
    local prev
    prev=$(get_previous_session)
    if [ -n "$prev" ]; then
        tmux switch-client -t "$prev"
    else
        tmux switch-client -t 0
    fi
}

case "$1" in
    push) push_session ;;
    get) get_previous_session ;;
    return) return_to_previous ;;
    clean) clean_history ;;
esac
