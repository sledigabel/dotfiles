#!/bin/bash
set -euo pipefail

# Advanced git status script for tmux status bar

GIT_DIR="${1:-.}"

if ! git -C "$GIT_DIR" rev-parse --git-dir >/dev/null 2>&1; then
  exit 0
fi

BRANCH=$(git -C "$GIT_DIR" branch --show-current 2>/dev/null)
if [ -z "$BRANCH" ]; then
  BRANCH=$(git -C "$GIT_DIR" rev-parse --short HEAD 2>/dev/null)
  BRANCH="$(printf '\xe2\x9a\xa1')${BRANCH}"  # ⚡ for detached HEAD
fi

STATUS=""

GIT_DIR_PATH=$(git -C "$GIT_DIR" rev-parse --git-dir 2>/dev/null)
if [ -f "$GIT_DIR_PATH/MERGE_HEAD" ]; then
  STATUS="${STATUS}$(printf '\xe2\x9a\xa0')"  # ⚠ for merge conflict
elif [ -d "$GIT_DIR_PATH/rebase-merge" ] || [ -d "$GIT_DIR_PATH/rebase-apply" ]; then
  STATUS="${STATUS}$(printf '\xe2\x86\xbb')"  # ↻ for rebase
elif [ -f "$GIT_DIR_PATH/CHERRY_PICK_HEAD" ]; then
  STATUS="${STATUS}$(printf '\xf0\x9f\x8d\x92')"  # 🍒 for cherry-pick
fi

if ! git -C "$GIT_DIR" diff-index --quiet HEAD -- 2>/dev/null; then
  STATUS="${STATUS}$(printf '\xe2\x9c\x8e')"  # ✎ for modified
fi

if [ -n "$(git -C "$GIT_DIR" ls-files --others --exclude-standard 2>/dev/null)" ]; then
  STATUS="${STATUS}$(printf '\xe2\x80\xa6')"  # … for untracked
fi

UPSTREAM=$(git -C "$GIT_DIR" rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null || echo "")
if [ -n "$UPSTREAM" ]; then
  AHEAD_BEHIND=$(git -C "$GIT_DIR" rev-list --left-right --count 'HEAD...@{u}' 2>/dev/null || echo "0 0")
  AHEAD=$(echo "$AHEAD_BEHIND" | awk '{print $1}')
  BEHIND=$(echo "$AHEAD_BEHIND" | awk '{print $2}')
  
  if [ "$AHEAD" -gt 0 ] && [ "$BEHIND" -gt 0 ]; then
    STATUS="${STATUS}$(printf '\xe2\x86\x95')"  # ↕ for diverged
  elif [ "$AHEAD" -gt 0 ]; then
    STATUS="${STATUS}$(printf '\xe2\x86\x91')"  # ↑ for ahead
  elif [ "$BEHIND" -gt 0 ]; then
    STATUS="${STATUS}$(printf '\xe2\x86\x93')"  # ↓ for behind
  fi
fi

if [ -n "$STATUS" ]; then
  STATUS=" ${STATUS}"
fi

echo "${BRANCH}${STATUS}"
