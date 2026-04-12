#!/bin/sh

resurrect_dir="$HOME/.dotfiles/tmux/resurrect"
current_session=$(tmux display-message -p '#S')

# Clean up command strings in the last file
sed 's/--cmd[^ ]* [^ ]* [^ ]*//g' "$resurrect_dir/last" | sponge "$resurrect_dir/last"

# Rename the last file to match the current session name
mv "$resurrect_dir/last" "$resurrect_dir/$current_session"
