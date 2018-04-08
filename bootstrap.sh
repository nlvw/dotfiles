#!/usr/bin/env bash
#
# bootstrap installs things.

# Set dotfile base directory as current
cd "$(dirname "$0")"
DOTFILES_ROOT=$(pwd -P)

# Stop Script on Error
set -e

# Create/Refresh dotfile symlinks (~/*)
for src in $(find -H "$DOTFILES_ROOT" -maxdepth 4 -name '*.symh' -not -path '*.git*')
do
  dst="$HOME/.$(basename "${src%.*}")"
  rm -rf "$dst" &>/dev/null || true
  ln -s "$src" "$dst"
done

# Create/Refresh dotfile symlinks (~/.config/*)
mkdir ~/.config &>/dev/null || true
for src in $(find -H "$DOTFILES_ROOT" -maxdepth 4 -name '*.symc' -not -path '*.git*')
do
  dst="$HOME/.config/$(basename "${src%.*}")"
  rm -rf "$dst" &>/dev/null || true
  ln -s "$src" "$dst"
done

# Setup Local User Git Info if Missing
if ! [ -f git/userinfo ]; then
  touch git/userinfo

  read -erp ' - What is your github author name? ' git_authorname
  read -erp ' - What is your github author email?' git_authoremail

  echo "[user]" > git/userinfo
  echo "name = ${git_authorname}" >> git/userinfo
  echo "email = ${git_authoremail}" >> git/userinfo
fi

# Setup SSH Files
if [ ! -f ~/.ssh/config ]; then
  mkdir ~/.ssh &>/dev/null || true
  touch ~/.ssh/config
  chmod -R 700 ~/.ssh
  echo "AddKeysToAgent yes" >> ~/.ssh/config
fi

# Install Vim-Plug & Plugins
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall

echo ''
echo '  All installed!'