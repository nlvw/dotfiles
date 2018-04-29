#!/usr/bin/env bash

# Setup For i3-gaps on OpenSuse Tumbleweed
# Server / Text Only Install

# Ensure script is being run as root 
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Stop on Error
set -e

# Disable automatic installation of reccomended packages
sed -i  '/solver.onlyRequires/c\solver.onlyRequires = true' /etc/zypp/zypp.conf

# Check for, and apply, updates
zypper ref
zypper dup -y

# Install GPU Driver
update-pciids
if lspci | grep -i 'vga\|3d\|2d\|nvidia\|NVIDIA'; then
    zypper addrepo --refresh http://http.download.nvidia.com/opensuse/tumbleweed/ NVIDIA
    zypper --gpg-autoimport-keys install -y x11-video-nvidiaG04
fi

# Install x11 (X Windows System)
zypper install --recommends -y -t pattern x11
systemctl set-default graphical

# Install/Configure Display Manager
zypper install -y lightdm-slick-greeter-branding-upstream
sed -i '/DISPLAYMANAGER=/c\DISPLAYMANAGER="lightdm"' /etc/sysconfig/displaymanager

# Install i3 and required apps for my config
zypper install -y i3-gaps i3lock rofi compton alacritty scrot feh ImageMagick pango
sed -i '/DEFAULT_WM=/c\DEFAULT_WM="i3"' /etc/sysconfig/windowmanager
ln -sfn /usr/share/xsessions/i3.desktop /etc/alternatives/default-xsession.desktop

# Install Polybar
zypper ar -f https://download.opensuse.org/repositories/home:/sysek/openSUSE_Tumbleweed/home:sysek.repo
zypper --gpg-auto-import-keys install -y polybar

# Install Audio -- pulseaudio-ctl?
zypper install -y pulseaudio pulseaudio-utils alsa-plugins-pulse pulseaudio-module-zeroconf pulseaudio-module-x11 pavucontrol

# Install Mulimedia Codecs
zypper ar -f http://packman.inode.at/suse/openSUSE_Tumbleweed/ packman
zypper ar -f http://opensuse-guide.org/repo/openSUSE_Tumbleweed/ libdvdcss
zypper --gpg-auto-import-keys install -y libdvdcss2 ffmpeg lame gstreamer-plugins-libav gstreamer-plugins-bad gstreamer-plugins-ugly gstreamer-plugins-ugly-orig-addon vlc vlc-codecs flash-player flash-player-ppapi libxine2 libxine2-codecs

# Install KVM
zypper install -y -t pattern kvm_server

# Install Docker
zypper install -y docker docker-compose
systemctl enable docker
systemctl start docker

# Install my preffered apps
zypper install -y vim tmux ranger git unzip clipit firefox discord libreoffice deluge qutebrowser gimp thunderbird audacity qpdfview

# Install visual studio code
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/zypp/repos.d/vscode.repo'
zypper refresh
zypper install -y code
