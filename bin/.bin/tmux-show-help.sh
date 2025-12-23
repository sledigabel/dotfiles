#!/bin/bash
set -euo pipefail

cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              TMUX CUSTOM KEYBINDINGS REFERENCE               ║
╔══════════════════════════════════════════════════════════════╗

SESSION MANAGEMENT:
  prefix + C-a    List and switch to sessions (excluding 0 and _*)
  prefix + C-b    Return to session 0 (home session)
  prefix + C-c    Show session tree browser
  prefix + C-k    Kill current session and return to previous
  prefix + C-p    Open project selector (fzf)
  prefix + C-n    Clone new project from git repository

SPECIAL SESSIONS:
  prefix + C-d    Open Obsidian daily notes
  prefix + C-r    Open Copilot chat
  prefix + C-m    Open mshell proxy

PROJECT TOOLS:
  prefix + C-l    Switch git branch (fzf)
  prefix + C-g    Open SourceTree for current project
  prefix + C-q    Cleanup idle sessions

PANES:
  prefix + |      Split pane horizontally
  prefix + -      Split pane vertically
  prefix + _      Split pane vertically (20% height)
  prefix + C-x    Toggle pane synchronization
  C-h/j/k/l       Navigate panes (vim-aware)

WINDOWS (macOS Option key):
  Option + .      Next window
  Option + ,      Previous window
  Option + t      New window in current path
  Option + 1-9    Switch to window 1-9
  Option + 0      Switch to window 10

OTHER:
  prefix + C-s    Toggle status bar visibility

╚══════════════════════════════════════════════════════════════╝
Press any key to continue...
EOF

read -n 1 -s -r
