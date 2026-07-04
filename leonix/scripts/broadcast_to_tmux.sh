broadcast() {
    for p in 1 2 3; do
        tmux send-keys -t "$TMUX_PANE:+$p" "$*" C-m
    done
}

broadcast uptime
