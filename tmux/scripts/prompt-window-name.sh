#!/bin/bash
# Validates and renames tmux window after new session creation

window_name="$1"

if [ -n "$window_name" ]; then
    tmux rename-window "$window_name"
else
    tmux display-message "Error: Window name cannot be empty"
fi
