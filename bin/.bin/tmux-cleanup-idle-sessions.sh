#!/bin/bash
# Terminates all sessions that only have idle shells running
# Safe to run - won't kill sessions with active processes

# Sessions to never kill (session 0 and _ prefixed special sessions)
PROTECTED_SESSION_PATTERN="^(0|_.*)$"

# Get list of all sessions
sessions=$(tmux list-sessions -F '#{session_name}' 2>/dev/null)

if [ -z "$sessions" ]; then
    echo "No tmux sessions found"
    exit 0
fi

# Function to check if a pane is running something other than a shell
is_pane_busy() {
    local pane_pid=$1
    local pane_tty=$2
    
    # Get all child processes and their commands
    local children
    children=$(pgrep -P "$pane_pid" 2>/dev/null)
    
    if [ -z "$children" ]; then
        return 1  # no children, idle
    fi
    
    # Check each child process
    while IFS= read -r child_pid; do
        # Get the command name for this child
        local cmd
        cmd=$(ps -p "$child_pid" -o comm= 2>/dev/null | tr -d ' ')
        
        # Ignore child processes that are just shells (zsh, bash, sh, etc.)
        # These are typically just the shell spawning itself
        case "$cmd" in
            zsh|bash|sh|dash|ksh|tcsh|csh|fish)
                # This is just a shell, check if it has non-shell children
                local grandchildren
                grandchildren=$(pgrep -P "$child_pid" 2>/dev/null)
                if [ -n "$grandchildren" ]; then
                    # Has grandchildren, check those too
                    local has_active_grandchild=0
                    while IFS= read -r grandchild_pid; do
                        local grandchild_cmd
                        grandchild_cmd=$(ps -p "$grandchild_pid" -o comm= 2>/dev/null | tr -d ' ')
                        case "$grandchild_cmd" in
                            zsh|bash|sh|dash|ksh|tcsh|csh|fish)
                                continue  # also just a shell
                                ;;
                            *)
                                has_active_grandchild=1
                                break
                                ;;
                        esac
                    done <<< "$grandchildren"
                    
                    if [ $has_active_grandchild -eq 1 ]; then
                        return 0  # busy - has non-shell grandchildren
                    fi
                fi
                # Just a shell with no active grandchildren, continue checking other children
                ;;
            *)
                # Non-shell process running, pane is busy
                return 0
                ;;
        esac
    done <<< "$children"
    
    return 1  # idle - only shells with no active processes
}

# Function to check if a session is safe to kill
is_session_safe() {
    local session=$1
    
    # Get all panes in this session
    local panes
    panes=$(tmux list-panes -s -t "$session" -F '#{pane_pid} #{pane_tty}' 2>/dev/null)
    
    if [ -z "$panes" ]; then
        return 1  # can't determine, don't kill
    fi
    
    # Check each pane
    while IFS= read -r pane_info; do
        local pane_pid
        local pane_tty
        pane_pid=$(echo "$pane_info" | awk '{print $1}')
        pane_tty=$(echo "$pane_info" | awk '{print $2}')
        
        if is_pane_busy "$pane_pid" "$pane_tty"; then
            return 1  # not safe, has running processes
        fi
    done <<< "$panes"
    
    return 0  # safe to kill
}

killed_count=0
kept_count=0

echo "Checking sessions for cleanup..."
echo

while IFS= read -r session; do
    # Skip protected sessions
    if [[ "$session" =~ $PROTECTED_SESSION_PATTERN ]]; then
        echo "⊘ $session - protected (skipped)"
        kept_count=$((kept_count + 1))
        continue
    fi
    
    # Check if session is safe to kill
    if is_session_safe "$session"; then
        echo "✓ $session - idle, terminating..."
        tmux kill-session -t "$session" 2>/dev/null
        killed_count=$((killed_count + 1))
    else
        echo "⊙ $session - has active processes (kept)"
        kept_count=$((kept_count + 1))
    fi
done <<< "$sessions"

echo
echo "Summary: Terminated $killed_count session(s), kept $kept_count session(s)"
