#!/usr/bin/env bash
#
# Took it and adapted it from ThePrimeagen - https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/scripts/tmux-sessionizer

joinByChar() {
    local IFS="$1"
    shift
    printf "$*"
}

if [[ $# -eq 1 ]]; then
    selected=$1
else
    readarray -t folders < <(
        find ~/dev/projects/ext/* -mindepth 1 -maxdepth 1 -type d
        find ~/dev/projects -mindepth 2 -maxdepth 2 -not -path "*/ext/*" -type d
    )

    concatenated_folders=$(joinByChar $'\n' ${folders[@]})

    selected=$(echo "${concatenated_folders}" | fzf --cycle --header="Project to create a session for" --no-scrollbar -e)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $selected_name -c $selected
    exit 0
fi

if ! tmux has-session -t=$selected_name 2> /dev/null; then
    tmux new-session -ds $selected_name -c $selected
fi

tmux switch-client -t $selected_name
