# Janus Linux Installer

This is the official installation script for **Janus Linux** — a next-gen Arch-based distro focused on hacking, automation, and TerminalGPT AI integration.

## 🧠 Features

- 🚀 Arch Linux base
- 🎛 Hyprland Wayland window manager
- 🧠 TerminalGPT (ChatGPT in your terminal)
- ⚔️ Pentesting and hacking tools
- 💻 Custom dotfiles (Hyprland, Kitty, Waybar, Neovim)

---

## 🔧 Installation Steps

> 🛑 You must boot from an Arch ISO and have your root partition mounted at `/mnt`.

### 1. Partition & Mount

```bash
cfdisk /dev/sdX
mkfs.ext4 /dev/sdXn
mount /dev/sdXn /mnt
