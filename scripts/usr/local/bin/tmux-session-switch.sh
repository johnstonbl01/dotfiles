#!/usr/bin/env bash

session_dir=$(find ~/dev -mindepth 2 -maxdepth 2 -type d | fzf)
session_name=$(basename "$session_dir" | tr . _ | tr ' ' _)

if ! tmux has-session -t "$session_name" 2> /dev/null; then
  tmux new-session -s "$session_name" -c "$session_dir" -d
fi

tmux switch-client -t "$session_name"
