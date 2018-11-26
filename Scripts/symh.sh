#!/usr/bin/env bash

if [ -d "$1" ]; then
    # Create/Refresh dotfile symlinks (~/*)
    for src in $(find -H "$1" -maxdepth 4 -name '*.symh' -not -path '*.git*'); do
        dst="$HOME/.$(basename "${src%.*}")"
        rm -rf "$dst" &>/dev/null || true
        ln -rsf "$src" "$dst"
    done
fi