#!/bin/bash

# Remove dotfiles if they exist
rm ~/.bash_aliases
rm ~/.bash_exports
rm ~/.bash_functions
rm ~/.bash_profile
rm ~/.bash_prompt
rm ~/.bashrc
rm ~/.gvimrc
rm ~/.inputrc
rm ~/.profile
rm ~/.tmux.conf
rm ~/.vimrc
rm ~/.wgetrc

# Create symlinks
ln -s .dotfiles/.bash_profile ~/
ln -s .dotfiles/.bashrc ~/
ln -s .dotfiles/.gvimrc ~/
ln -s .dotfiles/.inputrc ~/
ln -s .dotfiles/.profile ~/
ln -s .dotfiles/.tmux.conf ~/
ln -s .dotfiles/.vimrc ~/
ln -s .dotfiles/.wgetrc ~/
