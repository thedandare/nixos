#!/bin/sh
tmux new-session -d -s passthrough
tmux send-keys './vmscript.sh' Enter
tmux bind-key g display-popup -w 90% -h 90% -d '#{pane_current_path}' -E 'k9s'
    
