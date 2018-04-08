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
zypper install -y lightdm-slick-greeter-branding-upstream
sed -i  's#\(DISPLAYMANAGER=\)\(.*\)#\1"lightdm"#' /etc/sysconfig/displaymanager

# Install i3 and required apps for my config
zypper install -y i3-gaps i3lock rofi compton alacritty scrot feh ImageMagick pango
sed -i  's#\(DEFAULT_WM=\)\(.*\)#\1"i3"#' /etc/sysconfig/windowmanager
ln -sfn /usr/share/xsessions/i3.desktop /etc/alternatives/default-xsession.desktop

# Install Polybar
zypper ar https://download.opensuse.org/repositories/home:/sysek/openSUSE_Tumbleweed/home:sysek.repo
zypper --gpg-auto-import-keys refresh
zypper install -y polybar

# Install Audio
zypper install -y pulseaudio pulseaudio-utils alsa-plugins-pulse pulseaudio-module-zeroconf pulseaudio-module-x11 pavucontrol

# pulseaudio-ctl?

# Install my preffered apps
zypper install -y vim tmux ranger git unzip firefox 

# Install KVM
zypper install install -y -t pattern kvm_server kvm_tools

# Install Docker
zypper install -y docker docker-compose
systemctl enable docker
systemctl start docker

