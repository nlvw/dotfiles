#!/usr/bin/env bash

if [ -d "$1" ]; then
    # Create/Refresh dotfile symlinks (~/.config/*)
    mkdir ~/.config &>/dev/null || true
    for src in $(find -H "$1" -maxdepth 4 -name '*.symc' -not -path '*.git*'); do
        dst="$HOME/.config/$(basename "${src%.*}")"
        rm -rf "$dst" &>/dev/null || true
        ln -rsf "$src" "$dst"
    done
fi