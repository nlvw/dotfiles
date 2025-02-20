#!/usr/bin/env bash

# User Bin
if [ -d "$HOME/bin" ]; then
	PATH+=":$HOME/bin"
fi

# fix manpath if needed
if [ -z "$MANPATH" ]; then
	export MANPATH="$(manpath)"
fi

# .local paths
if [ -d "$HOME/.local/bin" ]; then
	export PATH="$HOME/.local/bin:$PATH"
fi

# Pixi Global Exports
if [ -d "$HOME/.pixi/bin" ]; then
	export PATH="$HOME/.pixi/bin:$PATH"
fi

# flatpak paths
if [ -d "$HOME/.local/bin/flatpak" ]; then
	export PATH="$HOME/.local/bin/flatpak:$PATH"
fi
if [ -n "$CONTAINER_ID" ]; then
	export PATH="$(echo "$PATH" | sed "s|$HOME/\.local/bin/flatpak||g")"
fi

# NPM Directory
if [ -d "$HOME/.local/npm-packages/bin" ]; then
	export NPM_PACKAGES="$HOME/.local/npm-packages"
	export PATH="$NPM_PACKAGES/bin:$PATH"
	export MANPATH="$NPM_PACKAGES/share/man:$MANPATH"
	export NODE_PATH="$NPM_PACKAGES:$NODE_PATH"
fi

# XDG Home
if [ -z "$XDG_CONFIG_HOME" ]; then
	export XDG_CONFIG_HOME="$HOME/.config"
fi

# XDG Run Dir
if [ -z "$XDG_RUNTIME_DIR" ]; then
	mkdir -p "/tmp/run-$EUID"
	chmod 700 "/tmp/run-$EUID"
	export XDG_RUNTIME_DIR="/tmp/run-$EUID"
fi

# Set Default Editor
if command -v nvim &>/dev/null; then
	export EDITOR='nvim '
elif command -v vim &>/dev/null; then
	export EDITOR='vim '
else
	export EDITOR='vi '
fi

# Make Python use UTF-8 encoding for output to stdin, stdout, and stderr.
export PYTHONIOENCODING='UTF-8';

# Increase Bash history size. Allow 32³ entries; the default is 500.
export HISTSIZE='32768';
export HISTFILESIZE="${HISTSIZE}";
# Omit duplicates and commands that begin with a space from history.
export HISTCONTROL='ignoreboth';

# Prefer US English and use UTF-8.
export LANG='en_US.UTF-8';
export LC_ALL='en_US.UTF-8';

# Highlight section titles in manual pages.
export LESS_TERMCAP_md="${yellow}";

# Don’t clear the screen after quitting a manual page.
export MANPAGER='less -X';

