#!/usr/bin/env zsh

SESSION_NAME="Notes"
LECTURE_NOTES_PATH="/home/jay/Documents/Notes/LectureNotes/"
ZETTELKASTEN_PATH="/home/jay/Documents/Notes/Zettelkasten/"

# Ensure tmux server is running
tmux start-server

# Start a new tmux session, detached
tmux new-session -d -s $SESSION_NAME -n 'Lecture Notes' -c $LECTURE_NOTES_PATH

# Start nvim in the first window
tmux send-keys -t $SESSION_NAME:0 'nvim' C-m

# Create the second window for Zettelkasten and start nvim
tmux new-window -t $SESSION_NAME -n 'Zettelkasten' -c $ZETTELKASTEN_PATH
tmux send-keys -t $SESSION_NAME:1 'nvim' C-m
