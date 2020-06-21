#!/bin/bash

# Install packages
sudo dnf install -y \
	wget \
	bind-utils \
	zip unzip \
	rsync \
	git \
	vim \
	emacs \
	neovim \
	ranger \
	tree \
	tmux \
	fzf \
	ripgrep \
  fd-find \
	pandoc \
	ShellCheck \
	llvm clang cmake expect rpmdevtools rpmlint \
	podman \
	buildah \
	toolbox \
	flatpak \
	google-roboto-condensed-fonts \
	google-roboto-fonts \
	google-roboto-mono-fonts \
	google-roboto-slab-fonts \
	adobe-source-code-pro-fonts

sudo dnf group install -y "Development Tools"

# Add Flatpak remote
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Source Dotfiles with bin created
mkdir -p "$HOME/.local/bin"
source "$HOME/.bash_profile"

# Install additional python packages
pip3 install --user ansible ansible-lint black pyflakes isort pipenv pytest nose
