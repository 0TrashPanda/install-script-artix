tmx () {
    # Use -d to allow the rest of the function to run
    tmux new-session -d -s minecraft
    tmux new-window -n extra-window
    # -d to prevent current window from changing
    tmux new-window -d -n waterfall
    tmux new-window -d -n lobby
    tmux new-window -d -n skyblock
    tmux new-window -d -n survival
    # -d to detach any other client (which there shouldn't be,
    # since you just created the session).
    tmux attach-session -d -t minecraft
}
