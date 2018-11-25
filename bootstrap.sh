#!/usr/bin/env bash

# Stop Script on Error
set -e

# Set dotfile base directory as current
DFROOT="$(dirname "$(readlink -f "$0")")"

# Setup Nix
if [ ! -L "$HOME/.nix-profile" ]; then
	read -p "Setup Nix (Yy/Nn)?? " -n 1 -r input
	echo
	if [[ $input =~ ^[Yy]$ ]]; then
		bash "$DFROOT/Scripts/nix-setup.sh"
	else
		echo "Skipping Nix Setup!!"
	fi
	unset input
fi

# Create/Refresh Symlinks For CLI Tool Dotfiles
bash "$DFROOT/Scripts/symc.sh" "$DFROOT/CLI"
bash "$DFROOT/Scripts/symh.sh" "$DFROOT/CLI"

# Create/Refresh Symlinks For GUI Tool Dotfiles
if [ ! -L "$HOME/.config/i3" ]; then
	read -p "Setup Dotfiles For GUI Tools (Yy/Nn)?? " -n 1 -r input
	echo
	if [[ $input =~ ^[Yy]$ ]]; then
		bash "$DFROOT/Scripts/symc.sh" "$DFROOT/GUI"
		bash "$DFROOT/Scripts/symh.sh" "$DFROOT/GUI"
	else
		echo "Skipping GUI Dotfiles!!"
	fi
	unset input
else
	bash "$DFROOT/Scripts/symc.sh" "$DFROOT/GUI"
	bash "$DFROOT/Scripts/symh.sh" "$DFROOT/GUI"
fi

# Setup Local User Git Info if Missing
if [ ! -f "$HOME/.config/git/userinfo" ]; then
  touch "$HOME/.config/git/userinfo"

  read -erp $' - What is your github author name?\n' git_authorname
  read -erp $' - What is your github author email?\n' git_authoremail

  echo "[user]" > "$HOME/.config/git/userinfo"
  echo "name = ${git_authorname}" >> "$HOME/.config/git/userinfo"
  echo "email = ${git_authoremail}" >> "$HOME/.config/git/userinfo"
fi

# Setup SSH Files
if [ ! -f ~/.ssh/config ]; then
  mkdir ~/.ssh &>/dev/null || true
  touch ~/.ssh/config
  chmod -R 700 ~/.ssh
  echo "AddKeysToAgent yes" >> ~/.ssh/config
fi

# Install Vim Plugins
if [ -z "$(ls "$HOME/.config/vim/plugged/")" ]; then
	vim -u "$HOME/.config/vim/vimrc.vim" +PlugInstall +qall
fi

echo ''
echo '  All installed!'
