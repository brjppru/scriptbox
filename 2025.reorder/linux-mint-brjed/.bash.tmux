if [ -z "$TMUX" ]; then
tmux attach -t term || tmux new -s term
fi
