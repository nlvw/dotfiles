#!/bin/bash

# Setup For i3-gaps on OpenSuse Tumbleweed
# Server / Text Only Install

# Check for, and apply, updates
dnf update && dnf upgrade -y

# Install x11 (X Windows System)
dnf groupinstall -y base-x
systemctl set-default graphical

# Install/Configure Display Manager
dnf install -y lightdm lightdm-gtk
systemctl enable lightdm.service

# Install i3-gaps
dnf copr enable gregw/i3desktop
dnf install -y i3-gaps i3status dmenu rofi i3lock

# Install i3 apps
dnf install -y compton rxvt-unicode-256color scrot feh

# Install Polybar
sudo dnf copr enable tomwishaupt/polybar
sudo dnf install -y polybar

# Install Audio


# Install basic cli apps
dnf install -y vim tmux ranger git unzip

# Install gui apps
dnf install -y firefox