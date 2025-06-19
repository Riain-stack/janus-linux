# Janus Dotfiles

These are the official dotfiles for **Janus Linux**, an AI-powered Arch-based hacking distro using Hyprland.

## Features

- ⚡ Tiling Wayland compositor (Hyprland)
- 🧠 AI in your terminal with TerminalGPT
- 🔐 Preconfigured for pentesters
- 🎨 Themed with Waybar, Kitty, Neovim

## Setup

```bash
git clone https://github.com/Riain-stack/janus-dotfiles ~/.janus-dotfiles
cp -r ~/.janus-dotfiles/.config ~/
cp ~/.janus-dotfiles/.zshrc ~/
```

> Edit `.zshrc` and add your OpenAI API key.

## Directory Breakdown

- `.zshrc` – shell config with TerminalGPT alias
- `.config/hypr/` – Hyprland tiling setup
- `.config/waybar/` – status bar config
- `.config/kitty/` – terminal settings
- `.config/nvim/` – minimal Neovim config

## License

MIT
