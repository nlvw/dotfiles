#!/bin/bash

# This Will Automate the Arch Linux Setup Steps After the user has installed and chrooted into the new installation
# UEFI and systemd-boot are default/assumed

# Kill script on error
set -e

# Set Current Directory to root home
cd ~

########################################################################################
# Get/Set Information From User
########################################################################################

# Hostname
read -rep "Desired Hostname: " hName

# Root Password
echo "Setting Root Password.  Please Input Desired Password: "
passwd

# New Admin User
read -rep "New Admin Desired User Name: " uName
useradd -m "$uName" -G wheel
echo "Setting $uName Password. Please Input Desired Password: "
passwd "$uName"

########################################################################################
# Hostname
########################################################################################
echo "$hName" > /etc/hostname
cat << EOF >> /etc/hosts
127.0.0.1	localhost
::1		    localhost
127.0.1.1	${hName}.localdomain	hName
EOF

########################################################################################
# Setup Locale/Time
########################################################################################

# Time Zone
ln -sf /usr/share/zoneinfo/US/Mountain /etc/localtime
hwclock --systohc

# Locale
echo LANG=en_US.UTF-8 > /etc/locale.conf
echo KEYMAP=us > /etc/vconsole.conf
locale-gen

########################################################################################
# Setup Bootloader
########################################################################################

# Set ESP/Boot directory
bootctl --path=/boot install

# Call "bootctl update" when systemd is updated
mkdir /etc/pacman.d/hooks || true
cat << EOF > /etc/pacman.d/hooks/systemd-boot.hook
[Trigger]
Type = Package
Operation = Upgrade
Target = systemd

[Action]
Description = Updating systemd-boot
When = PostTransaction
Exec = /usr/bin/bootctl update
EOF

# Set Loader Configuration
cat << EOF > /boot/loader/loader.conf
default arch
timeout 3
editor 0
console-mode auto
EOF

# Create Boot Entry
puID=$(findmnt / -o PARTUUID -n)
mkdir /boot/loader/entries || true
cat << EOF > /boot/loader/entries/arch.conf
title Arch Linux
linux /vmlinuz-linux
initrd /initramfs-linux.img
options root=PARTUUID=$puID rw
EOF

# Update boot partition just in case
bootctl update

########################################################################################
# Setup Sudo
########################################################################################
pacman -S --noconfirm sudo

echo "%wheel      ALL=(ALL) ALL" > /etc/sudoers.d/wheel
chmod -c 0440 /etc/sudoers.d/wheel

#echo "$uName      ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${uName}"
#chmod -c 0440 "/etc/sudoers.d/${uName}"


########################################################################################
# Networking
########################################################################################
pacman -S --noconfirm networkmanager
ln -sf /usr/lib/systemd/system/NetworkManager.service /etc/systemd/system/dbus-org.freedesktop.NetworkManager.service
ln -sf /usr/lib/systemd/system/NetworkManager-dispatcher.service /etc/systemd/system/dbus-org.freedesktop.nm-dispatcher.service
ln -sf /usr/lib/systemd/system/NetworkManager.service /etc/systemd/system/multi-user.target.wants/NetworkManager.service

########################################################################################
# Firewall
########################################################################################
pacman -S --noconfirm iptables ufw
ufw enable
ufw logging medium
ufw default deny incoming
ufw default allow outgoing
ufw reload

########################################################################################
# Install Core Utilities
########################################################################################
pacman -S --noconfirm base-devel vim wget git

########################################################################################
# Install AUR Helper
########################################################################################
cat << EOF >> /etc/pacman.conf

[archlinuxfr]
SigLevel = Never
Server = http://repo.archlinux.fr/$arch
EOF

pacman -Syy
pacman -S --noconfirm yaourt

########################################################################################
# Install / Setup I3 Graphical Env
########################################################################################
pacman -S --noconfirm i3-gaps xorg xorg-xinit 

########################################################################################
# Install Polybar
########################################################################################



