#!/bin/bash
# Creates a new tmux window only if name is provided

window_name="$1"
pane_path="$2"

if [ -n "$window_name" ]; then
    tmux new-window -n "$window_name" -c "$pane_path"
else
    tmux display-message "Error: Window name cannot be empty"
fi
