#!/bin/bash

# Janus Linux Installer
# Author: Riain-stack
# Target: Arch-based hacking & AI-augmented distro

set -e

USERNAME=janus
HOSTNAME=janus-linux

# Ensure script is run with root privileges
if [[ $EUID -ne 0 ]]; then
  echo "❌ Run this as root or with sudo."
  exit 1
fi

echo "🔧 Starting Janus Linux installation..."

# Set time
timedatectl set-ntp true

# Mount (assumes /mnt is ready)
read -p "Have you partitioned and mounted your root partition at /mnt? [y/N] " answer
[[ "$answer" != "y" ]] && echo "❌ Please partition and mount first." && exit 1

# Base system
pacstrap /mnt base base-devel linux linux-firmware git zsh sudo networkmanager

# Fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Enter chroot
arch-chroot /mnt /bin/bash <<EOF

echo "🌐 Configuring locale and hostname..."
ln -sf /usr/share/zoneinfo/UTC /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "$HOSTNAME" > /etc/hostname

echo "👤 Creating user..."
useradd -m -G wheel -s /bin/zsh $USERNAME
echo "$USERNAME:janus" | chpasswd
echo "root:janus" | chpasswd
echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers

echo "🚀 Enabling services..."
systemctl enable NetworkManager

echo "🎛 Installing graphical stack..."
pacman -S --noconfirm hyprland waybar kitty rofi thunar neovim wl-clipboard xdg-desktop-portal-hyprland

echo "🔐 Installing hacking tools..."
pacman -S --noconfirm nmap wireshark-qt aircrack-ng metasploit bettercap john hashcat nikto gobuster

echo "🧠 Installing TerminalGPT..."
pacman -S --noconfirm python-pip
pip install terminalgpt

echo "📁 Fetching dotfiles..."
cd /home/$USERNAME
git clone https://github.com/Riain-stack/janus-dotfiles.git
cp -r janus-dotfiles/.config .config
cp janus-dotfiles/.zshrc .
chown -R $USERNAME:$USERNAME .config .zshrc janus-dotfiles

EOF

echo "✅ Installation complete! Reboot, login as '$USERNAME' (password: janus), and enjoy Janus Linux."
