# Janus Linux Installer

This is the official installer for **Janus Linux** — a next-gen, Arch-based Linux distribution built for hackers, automation pros, and AI enthusiasts. Featuring Hyprland, TerminalGPT, and essential pentesting tools out of the box.

---

## ⚡ Features

- 🧠 TerminalGPT (OpenAI in your terminal)
- 🎛 Hyprland Wayland tiling window manager
- 🎨 Preconfigured with Kitty, Waybar, Neovim
- 🔐 Pentesting tools (Metasploit, Nmap, Aircrack-ng, etc.)
- 🛠 Custom dotfiles (Hyprland, zsh, nvim, and more)

---

## 🧰 Requirements

- Booted from an **Arch Linux ISO**
- Active internet connection
- Mounted root partition at `/mnt`
- UEFI system with EFI partition mounted at `/mnt/boot`

---

## 🚀 Installation

1. Boot into the Arch ISO.
2. Partition and format your drive:

```bash
cfdisk /dev/sdX
mkfs.ext4 /dev/sdXn
mount /dev/sdXn /mnt
mount /dev/sdXn_efi /mnt/boot  # if EFI partition exists
```

3. Download and run the installer:

```bash
curl -LO https://yourserver.com/janus-install.sh
chmod +x janus-install.sh
./janus-install.sh
```

4. Follow the prompts to configure your hostname, users, and more.

5. Reboot when prompted.

---

## 🧠 TerminalGPT Setup

After booting into your new system, open a terminal and edit your `.zshrc` to include your OpenAI API key:

```bash
export OPENAI_API_KEY="your-api-key"
```

Now use the `gpt` command from your terminal to chat with AI.

---

## 📁 Dotfiles Included

- Hyprland configuration: `.config/hypr/`
- Waybar: `.config/waybar/`
- Kitty terminal: `.config/kitty/`
- Neovim: `.config/nvim/`
- ZSH with GPT alias: `.zshrc`

---

## 🪪 License

MIT © 2025 Riain Stack
