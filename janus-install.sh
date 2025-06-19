#!/bin/bash
set -e

# Janus Linux Installer Script
# Assumes root partition is mounted at /mnt

echo "[+] Setting timezone, locale, and base packages..."
ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

read -p "Enter hostname: " hostname
echo "$hostname" > /etc/hostname

echo "[+] Installing base system..."
pacstrap /mnt base linux linux-firmware vim git sudo networkmanager zsh

echo "[+] Generating fstab..."
genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt /bin/bash <<EOF
echo "[+] Inside chroot environment..."

# Time & Locale
ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo "[+] Setting hostname and hosts..."
echo "$hostname" > /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 $hostname.localdomain $hostname" >> /etc/hosts

echo "[+] Setting root password..."
passwd

echo "[+] Creating user 'janus'..."
useradd -m -G wheel -s /bin/zsh janus
passwd janus
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

echo "[+] Enabling NetworkManager..."
systemctl enable NetworkManager

echo "[+] Installing Hyprland and GUI packages..."
pacman -S --noconfirm xdg-desktop-portal-hyprland hyprland waybar kitty neovim firefox unzip

echo "[+] Installing TerminalGPT (OpenAI CLI wrapper)..."
pip install openai
echo "alias gpt='python3 -m openai chat'" >> /home/janus/.zshrc

echo "[+] Cloning dotfiles..."
sudo -u janus git clone https://github.com/Riain-stack/janus-dotfiles /home/janus/.janus-dotfiles
cp -r /home/janus/.janus-dotfiles/.config /home/janus/.config
cp /home/janus/.janus-dotfiles/.zshrc /home/janus/.zshrc
chown -R janus:janus /home/janus

echo "[+] Installing pentesting tools..."
pacman -S --noconfirm nmap metasploit wireshark-qt aircrack-ng john

echo "[+] Installing GRUB bootloader..."
pacman -S --noconfirm grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

echo "[+] Done inside chroot."
EOF

echo "[✓] Janus Linux installed! Reboot after removing installation media."
