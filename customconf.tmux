#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

main() {
    tmux source-file "$CURRENT_DIR/tmux.static.conf"
    tmux source-file "$CURRENT_DIR/theme.conf"

    tmux bind-key S run-shell "$CURRENT_DIR/scripts/sessionizer.sh"
}

main
