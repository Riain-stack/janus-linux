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

echo "🎨 Installing fonts and wallpapers..."
pacman -S --noconfirm ttf-jetbrains-mono ttf-fira-code ttf-nerd-fonts-symbols noto-fonts noto-fonts-emoji

mkdir -p /usr/share/backgrounds/janus
curl -Lo /usr/share/backgrounds/janus/janus-wallpaper.jpg https://w.wallhaven.cc/full/dg/wallhaven-dg8v3l.jpg

# Optional: set wallpaper in Hyprland config
sed -i '/exec-once/a exec-once = swaybg -i /usr/share/backgrounds/janus/janus-wallpaper.jpg -m fill' /home/$USERNAME/janus-dotfiles/.config/hypr/hyprland.conf || true

echo "📁 Fetching dotfiles..."
cd /home/$USERNAME
git clone https://github.com/Riain-stack/janus-dotfiles.git
cp -r janus-dotfiles/.config .config
cp janus-dotfiles/.zshrc .
chown -R $USERNAME:$USERNAME .config .zshrc janus-dotfiles

echo "🔐 Installing swaylock-effects and swayidle..."
pacman -S --noconfirm swaylock-effects swayidle

# Configure lock screen command
LOCK_CMD="swaylock -f -c 000000 -B 5 -S 255 --grace 0 --fade-in 0.3"

# Lock script
cat <<EOL > /home/$USERNAME/.config/hypr/lock.sh
#!/bin/bash
$LOCK_CMD
EOL
chmod +x /home/$USERNAME/.config/hypr/lock.sh

# Add idle + suspend + lock config
cat <<EOL >> /home/$USERNAME/.config/hypr/hyprland.conf

exec-once = swayidle -w \\
  timeout 300 '/home/$USERNAME/.config/hypr/lock.sh' \\
  timeout 600 'systemctl suspend' \\
  resume 'hyprctl dispatch dpms on'

bind = SUPER, L, exec, /home/$USERNAME/.config/hypr/lock.sh
EOL


EOF

echo "✅ Installation complete! Reboot, login as '$USERNAME' (password: janus), and enjoy Janus Linux."
