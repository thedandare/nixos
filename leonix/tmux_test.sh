#!/bin/sh
tmux new-session -d -s passthrough
tmux send-keys './vmscript.sh' Enter
