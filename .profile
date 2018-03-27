#!/usr/bin/env bash

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin directories
PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# if in tty
if [ "$TERM" == "linux" ]; then
setfont /usr/share/consolefonts/Uni3-TerminusBold24x12.psf.gz
fi