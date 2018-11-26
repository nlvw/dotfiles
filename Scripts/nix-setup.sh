#!/usr/bin/env bash

# Install Nix
curl https://nixos.org/nix/install | sh
source "$HOME/.nix-profile/etc/profile.d/nix.sh"

# Install Applications and Fonts
read -p "Install Nix Applications (Yy/Nn)?? " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    # Install Nix Packages
    nix-env -i vim neovim emacs ranger tmux git fzf shellcheck pandoc pango source-code-pro nerdfonts roboto roboto-mono roboto-slab

    # Link Nix Fonts
    mkdir -p ~/.local/share/fonts
    ln -sf "$HOME/.nix-profile/share/fonts" ~/.local/share/fonts/nix_fonts

    # Setup Spacemacs
    if [ ! -d "$HOME/.emacs.d" ]; then
        git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
    fi
else
    echo "Skipping GUI Dotfiles!!"
fi
unset REPLY
