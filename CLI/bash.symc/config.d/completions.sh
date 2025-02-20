#!/usr/bin/env bash

# Bash
if [ -f /etc/bash_completion ]; then
	source /etc/bash_completion
fi

# Zellij
if which --skip-alias --skip-functions zellij &>/dev/null; then
	eval "$(zellij setup --generate-completion bash)"
fi

# Homebrew
#if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
#	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
#fi

# Nix
#if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
#        source "$HOME/.nix-profile/etc/profile.d/nix.sh"
#        export LOCALE_ARCHIVE_2_11="$(nix-build --no-out-link "<nixpkgs>" -A glibcLocales)/lib/locale/locale-archive"
#        export LOCALE_ARCHIVE_2_27="$(nix-build --no-out-link "<nixpkgs>" -A glibcLocales)/lib/locale/locale-archive"
#        export LOCALE_ARCHIVE="/usr/bin/locale"
#fi

# Git
if [ -f "/usr/share/bash-completion/completions/git" ]; then
	source "/usr/share/bash-completion/completions/git"
fi

# SSH
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh

# Pixi
if command -v pixi &>/dev/null; then
	eval "$(pixi completion --shell bash)"
fi

