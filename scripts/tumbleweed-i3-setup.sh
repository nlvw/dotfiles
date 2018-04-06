#!/bin/bash

# Setup For i3-gaps on OpenSuse Tumbleweed
# Server / Text Only Install

# Check for, and apply, updates
zypper ref
zypper dup -y

# Install x11 (X Windows System)
zypper install -y -t pattern x11
systemctl set-default graphical

# Install/Configure Display Manager
zypper install -y lightdm-gtk-greeter-branding-openSUSE
sed -i  's#\(DISPLAYMANAGER=\)\(.*\)#\1"lightdm"#' /etc/sysconfig/displaymanager

# Install i3-gaps
zypper install -y i3-gaps rofi compton alacritty rxvt-unicode urxvt-font-size urxvt-perls scrot feh
sed -i  's#\(DEFAULT_WM=\)\(.*\)#\1"i3"#' /etc/sysconfig/windowmanager

# Install Polybar
zypper ar https://download.opensuse.org/repositories/home:/sysek/openSUSE_Tumbleweed/home:sysek.repo
zypper --gpg-auto-import-keys refresh
zypper install -y polybar

# Install Audio
zypper install -y pulseaudio pulseaudio-utils alsa-plugins-pulse pulseaudio-module-zeroconf pulseaudio-module-x11 pulseaudio-ctl pavucontrol

# Install basic cli apps
zypper install -y vim tmux ranger git unzip

# Install gui apps
zypper install -y firefox

# Rice It Up!!
if [ ! -f ~/.dotfiles/bootstrap.sh ]; then
    git clone https://github.com/Wolfereign/.dotfiles.git
    bash ~/.dotfiles/bootstrap.sh
fi