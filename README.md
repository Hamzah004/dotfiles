
# My dotfiles

<div align="center">

![desktop](Pictures/screenshots/img1.png)

</div>

---
## 📦 Configs

| App | Description |
|:---|:---|
| **Sway** | Tiling Wayland compositor (wlroots) |
| **Alacritty** | GPU-accelerated terminal emulator |
| **Kitty** | Fast, feature-rich terminal |
| **Neovim** | Hacked Vim — config & plugins |
| **Zsh** | Shell with Oh My Zsh & Starship prompt |
| **Fish** | Smart and user-friendly shell |
| **Fastfetch** | Fast system info fetch |
| **Rofi** | Application launcher & window switcher |
| **Waybar** | Modern status bar for Wayland |
| **Swaylock** | Screen locker |
| **Swaync** | Notification center |
| **Starship** | Cross-shell prompt |
| **NixOS** | Declarative system config |
| **Wallpaper** | Desktop backgrounds |

---

## ⚡ Quick Start

```bash
# Clone your bare dotfiles repo
git clone --bare <repo-url> $HOME/.dotfiles

# Add the alias
echo "alias dotfiles='/usr/bin/git --git-dir=\$HOME/.dotfiles/ --work-tree=\$HOME'" >> \$HOME/.zshrc

# Reload shell
source \$HOME/.zshrc

# Deploy everything
dotfiles checkout

# Hide untracked files from status
dotfiles config --local status.showUntrackedFiles no
```

---
