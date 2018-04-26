#!/bin/bash

########################################################################################
# Setup Install Env
########################################################################################
# Error Handling
set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

# Logs
exec 1> >(tee "stdout.log")
exec 2> >(tee "stderr.log")

# Sync Time
timedatectl set-ntp true

# Rank Mirrors
echo "Updating mirror list"
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.original
rankmirrors -n 6 /etc/pacman.d/mirrorlist.original > /etc/pacman.d/mirrorlist

########################################################################################
# Get/Set Information From User
########################################################################################
hostname=$(dialog --stdout --inputbox "Enter hostname" 0 0) || exit 1
clear
: ${hostname:?"hostname cannot be empty"}

user=$(dialog --stdout --inputbox "Enter admin username" 0 0) || exit 1
clear
: ${user:?"user cannot be empty"}

password=$(dialog --stdout --passwordbox "Enter admin password" 0 0) || exit 1
clear
: ${password:?"password cannot be empty"}
password2=$(dialog --stdout --passwordbox "Enter admin password again" 0 0) || exit 1
clear
[[ "$password" == "$password2" ]] || ( echo "Passwords did not match"; exit 1; )

devicelist=$(lsblk -dplnx size -o name,size | grep -Ev "boot|rpmb|loop" | tac)
device=$(dialog --stdout --menu "Select installtion disk" 0 0 0 ${devicelist}) || exit 1
clear

########################################################################################
# Partitioning & Mounting
########################################################################################

# Set Swap Size
swap_size=$(free --mebi | awk '/Mem:/ {print $2}')
swap_end=$(( $swap_size + 954 + 1 ))MiB

# Repartition disk
parted --script "${device}" \
        mklabel gpt \
        mkpart ESP fat32 1MiB 954MiB name 1 boot set 1 esp on \
        mkpart primary linux-swap 1GiB ${swap_end} name 2 swap \
        mkpart primary ext4 ${swap_end} 100% name 3 arch

# Simple globbing was not enough as on one device I needed to match /dev/mmcblk0p1 
# but not /dev/mmcblk0boot1 while being able to match /dev/sda1 on other devices.
part_boot="$(ls ${device}* | grep -E "^${device}p?1$")"
part_swap="$(ls ${device}* | grep -E "^${device}p?2$")"
part_root="$(ls ${device}* | grep -E "^${device}p?3$")"

# Clean Partitions
wipefs --all --force "${part_boot}"
wipefs --all --force "${part_swap}"
wipefs --all --force "${part_root}"

# Format Partitions
mkfs.vfat -F 32 -n boot "${part_boot}"
mkswap -L swap "${part_swap}"
mkfs.ext4 -F -L arch "${part_root}"

# Mount Partitions
printf "Mounting Partitions!\n"
mount /dev/disk/by-label/arch /mnt
mkdir /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

########################################################################################
# Install Arch Linux
########################################################################################

# Add My Custom AUR Repo
#cat >>/etc/pacman.conf <<EOF
#[mdaffin]
#SigLevel = Optional TrustAll
#Server = $REPO_URL
#EOF

# Install System
#pacstrap /mnt mdaffin-desktop
pacstrap /mnt

# Generate FStab
genfstab -t PARTUUID /mnt >> /mnt/etc/fstab

# Set Hostname
echo "${hostname}" > /mnt/etc/hostname

# Add My Custom AUR Repo
#cat >>/mnt/etc/pacman.conf <<EOF
#[mdaffin]
#SigLevel = Optional TrustAll
#Server = $REPO_URL
#EOF

########################################################################################
# Setup Bootloader
########################################################################################

# Set ESP/Boot directory
arch-chroot /mnt bootctl --path=/boot install

# Call "bootctl update" when systemd is updated
mkdir /mnt/etc/pacman.d/hooks || true
cat << EOF > /mnt/etc/pacman.d/hooks/systemd-boot.hook
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
cat << EOF > /mnt/boot/loader/loader.conf
default arch
timeout 3
editor 0
console-mode auto
EOF

# Create Boot Entry
mkdir /boot/loader/entries || true
cat << EOF > /mnt/boot/loader/entries/arch.conf
title Arch Linux
linux /vmlinuz-linux
initrd /initramfs-linux.img
options root=PARTUUID=$(blkid -s PARTUUID -o value "$part_root") rw
EOF

# Update boot partition just in case
bootctl update

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
ln -sf /mnt/usr/share/zoneinfo/US/Mountain /mnt/etc/localtime
arch-chroot /mnt hwclock --systohc

# Locale
echo LANG=en_US.UTF-8 > /mnt/etc/locale.conf
echo KEYMAP=us > /mnt/etc/vconsole.conf
arch-chroot /mnt locale-gen

########################################################################################
# User Configuration
########################################################################################
arch-chroot /mnt useradd -mU -s /usr/bin/bash -G wheel,uucp,video,audio,storage,games,input "$user"

echo "$user:$password" | chpasswd --root /mnt
echo "root:$password" | chpasswd --root /mnt

########################################################################################
# Setup Sudo
########################################################################################
arch-chroot /mnt pacman -S --noconfirm sudo

echo "%wheel      ALL=(ALL) ALL" > /mnt/etc/sudoers.d/wheel
chmod -c 0440 /mnt/etc/sudoers.d/wheel

echo "$user      ALL=(ALL) NOPASSWD: ALL" > "/mnt/etc/sudoers.d/${user}"
chmod -c 0440 "/mnt/etc/sudoers.d/${user}"


########################################################################################
# Networking
########################################################################################
arch-chroot /mnt pacman -S --noconfirm networkmanager
arch-chroot /mnt systemctl enable NetworkManager
#arch-chroot /mnt ln -sf /usr/lib/systemd/system/NetworkManager.service /etc/systemd/system/dbus-org.freedesktop.NetworkManager.service
#arch-chroot /mnt ln -sf /usr/lib/systemd/system/NetworkManager-dispatcher.service /etc/systemd/system/dbus-org.freedesktop.nm-dispatcher.service
#arch-chroot /mnt ln -sf /usr/lib/systemd/system/NetworkManager.service /etc/systemd/system/multi-user.target.wants/NetworkManager.service

########################################################################################
# Firewall
########################################################################################
arch-chroot /mnt pacman -S --noconfirm iptables ufw
arch-chroot /mnt ufw enable
arch-chroot /mnt ufw logging medium
arch-chroot /mnt ufw default deny incoming
arch-chroot /mnt ufw default allow outgoing
arch-chroot /mnt ufw reload

########################################################################################
# Install Core Utilities
########################################################################################
arch-chroot /mnt pacman -S --noconfirm base-devel vim wget git

########################################################################################
# Install AUR Helper
########################################################################################
cat << EOF >> /mnt/etc/pacman.conf

[archlinuxfr]
SigLevel = Never
Server = http://repo.archlinux.fr/$arch
EOF

arch-chroot /mnt pacman -Syy
arch-chroot /mnt pacman -S --noconfirm yaourt

########################################################################################
# Install / Setup I3 Graphical Env
########################################################################################
arch-chroot /mnt pacman -S --noconfirm i3-gaps xorg xorg-xinit 

########################################################################################
# Install Polybar
########################################################################################



