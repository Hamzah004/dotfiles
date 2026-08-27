#!/usr/bin/env bash
# =============================================================================
# Arch Linux Environment Setup
# Migrated from NixOS configuration
# =============================================================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log()    { echo -e "${GREEN}[✓]${NC} $1"; }
warn()   { echo -e "${YELLOW}[!]${NC} $1"; }
error()  { echo -e "${RED}[✗]${NC} $1"; exit 1; }
header() { echo -e "\n${BLUE}══════════════════════════════════════${NC}"; echo -e "${BLUE}  $1${NC}"; echo -e "${BLUE}══════════════════════════════════════${NC}"; }

if [[ "$EUID" -eq 0 ]]; then
  error "Do not run this script as root. Run as your normal user (with sudo access)."
fi

# =============================================================================
# 1. INSTALL YAY (AUR helper)
# =============================================================================
header "AUR Helper (yay)"
if ! command -v yay &>/dev/null; then
  sudo pacman -S --noconfirm --needed git base-devel
  tmpdir=$(mktemp -d)
  git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
  (cd "$tmpdir/yay" && makepkg -si --noconfirm)
  rm -rf "$tmpdir"
  log "yay installed"
else
  log "yay already installed, skipping"
fi

# =============================================================================
# 2. MIRROR SETUP (rate-mirrors)
# =============================================================================
header "Mirror Setup"

# Backup the current mirrorlist before making any changes
sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
log "Mirrorlist backed up to /etc/pacman.d/mirrorlist.bak"

if ! command -v rate-mirrors &>/dev/null; then
  yay -S --noconfirm --needed rate-mirrors-bin
  log "rate-mirrors installed"
else
  log "rate-mirrors already installed, skipping"
fi

# Rank HTTPS-only Arch mirrors and write them to the mirrorlist
rate-mirrors --allow-root --protocol https arch | grep -v '^#' | sudo tee /etc/pacman.d/mirrorlist
log "Mirrorlist updated with fastest HTTPS mirrors"

# =============================================================================
# 3. SYSTEM UPDATE
# =============================================================================
header "System Update"
sudo pacman -Syu --noconfirm
log "System updated"

# =============================================================================
# 4. PACMAN PACKAGES
# =============================================================================
header "Core Pacman Packages"

PACMAN_PACKAGES=(
  # --- General System ---
  neovim
  git
  curl
  wget
  ripgrep
  alacritty
  ghostty
  fastfetch
  starship
  trash-cli
  ranger
  opencode
  mandb
  man-pages
  brightnessctl
  bat
  zoxide
  eza
  clang
  pnpm
  npm

  # --- Sway core ---
  sway
  waybar
  swaybg
  swaylock
  swayidle

  # --- Wayland utilities ---
  wl-clipboard          # wl-copy / wl-paste
  slurp                 # region select for screenshots
  grim                  # screenshot tool for Wayland
  libnotify             # notify-send
  playerctl             # media key control
  wtype                 # xdotool replacement for Wayland
  wlsunset              # night light / blue light filter

  # --- XWayland (X11 app compatibility) ---
  xorg-xwayland

  # --- Screen sharing on Wayland ---
  xdg-desktop-portal
  xdg-desktop-portal-wlr

  # --- App launcher ---
  rofi-wayland          # rofi with Wayland support

  # --- NetworkManager ---
  networkmanager
  network-manager-applet

  # --- Bluetooth ---
  bluez
  bluez-utils
  blueman

  # --- Audio (Pipewire stack) ---
  pipewire
  pipewire-alsa
  pipewire-pulse
  pipewire-jack
  wireplumber
  rtkit
  pavucontrol

  # --- Printing (CUPS) ---
  cups

  # --- KDE / Dolphin file manager ---
  dolphin
  ffmpegthumbs
  kdegraphics-thumbnailers
  ark
  kio-fuse
  gvfs
  okular

  # --- Polkit ---
  lxsession             # provides lxpolkit

  # --- Theming & icons ---
  papirus-icon-theme
  adwaita-icon-theme
  hicolor-icon-theme
  gnome-themes-extra
  glib2
  gsettings-desktop-schemas

  # --- Qt Wayland support ---
  qt5-wayland
  qt6-wayland

  # --- Fonts ---
  ttf-meslo-nerd
  ttf-jetbrains-mono-nerd
  noto-fonts
  noto-fonts-emoji
  noto-fonts-cjk

  # --- Firefox ---
  firefox
)

sudo pacman -S --noconfirm --needed "${PACMAN_PACKAGES[@]}"
log "Pacman packages installed"

# =============================================================================
# 5. AUR PACKAGES
# =============================================================================
header "AUR Packages"

AUR_PACKAGES=(
  discord               # Discord desktop app
  swaync                # sway notification center
  rofimoji              # emoji picker for rofi
  nwg-look              # GTK settings editor for Wayland
  clipman               # clipboard history manager for Wayland
  visual-studio-code-bin # official Microsoft build of vscode
)

yay -S --noconfirm --needed "${AUR_PACKAGES[@]}"
log "AUR packages installed"

# =============================================================================
# 6. DISCORD — WAYLAND SCREEN SHARING FIX
# =============================================================================
header "Discord Screen Sharing Fix"

DISCORD_DESKTOP="/usr/share/applications/discord.desktop"
if [[ -f "$DISCORD_DESKTOP" ]]; then
  if ! grep -q "WebRTCPipeWireCapturer" "$DISCORD_DESKTOP"; then
    sudo sed -i 's|Exec=/usr/bin/discord|Exec=/usr/bin/discord --enable-features=WebRTCPipeWireCapturer|' "$DISCORD_DESKTOP"
    log "Discord patched for PipeWire screen sharing"
  else
    log "Discord already patched, skipping"
  fi
else
  warn "Discord .desktop file not found at $DISCORD_DESKTOP — patch it manually after install"
fi

# =============================================================================
# 7. ENABLE SYSTEM SERVICES
# =============================================================================
header "System Services"

sudo systemctl enable --now NetworkManager
log "NetworkManager enabled"

sudo systemctl enable --now bluetooth
log "Bluetooth enabled"

sudo systemctl enable --now cups
log "CUPS (printing) enabled"

# Pipewire runs as user services
systemctl --user enable --now pipewire
systemctl --user enable --now pipewire-pulse
systemctl --user enable --now wireplumber
log "Pipewire audio stack enabled (user services)"

# xdg-desktop-portal user service
systemctl --user enable --now xdg-desktop-portal
systemctl --user enable --now xdg-desktop-portal-wlr
log "xdg-desktop-portal enabled (screen sharing)"

# =============================================================================
# 8. SWAY — WAYLAND ENV + SCREEN SHARING SETUP
# =============================================================================
# header "Sway Config Scaffold"
#
# SWAY_CONFIG_DIR="$HOME/.config/sway"
# mkdir -p "$SWAY_CONFIG_DIR"
#
# if [[ ! -f "$SWAY_CONFIG_DIR/config" ]]; then
#   if [[ -f /etc/sway/config ]]; then
#     cp /etc/sway/config "$SWAY_CONFIG_DIR/config"
#     log "Default sway config copied to ~/.config/sway/config"
#   else
#     warn "No default sway config found — create ~/.config/sway/config manually"
#   fi
# else
#   log "Sway config already exists, skipping copy"
# fi

# Inject dbus environment lines needed for screen sharing & portals
# (safe to add — checks for duplicates first)
# SWAY_CONFIG="$SWAY_CONFIG_DIR/config"
# if [[ -f "$SWAY_CONFIG" ]] && ! grep -q "dbus-update-activation-environment" "$SWAY_CONFIG"; then
#   cat >> "$SWAY_CONFIG" <<'EOF'

# --- Wayland portal & screen sharing (added by arch-install.sh) ---
# exec dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
# exec systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
# EOF
#   log "Wayland portal env lines added to sway config"
# fi
#
# mkdir -p "$HOME/.config/waybar"
# log "~/.config/waybar directory ready"
#
# mkdir -p "$HOME/.config/swaync"
# log "~/.config/swaync directory ready"

# =============================================================================
# 9. STARSHIP PROMPT
# =============================================================================
header "Starship Prompt"

SHELL_RC="$HOME/.bashrc"
if [[ "$SHELL" == */zsh ]]; then
  SHELL_RC="$HOME/.zshrc"
fi

if ! grep -q 'starship init' "$SHELL_RC" 2>/dev/null; then
  echo '' >> "$SHELL_RC"
  echo '# Starship prompt' >> "$SHELL_RC"
  echo 'eval "$(starship init bash)"' >> "$SHELL_RC"
  log "Starship added to $SHELL_RC"
else
  log "Starship already configured in $SHELL_RC"
fi

# =============================================================================
# 10. LOCALE & TIMEZONE
# =============================================================================
# header "Locale & Timezone"
#
# sudo timedatectl set-timezone Asia/Amman
# log "Timezone set to Asia/Amman"
#
# sudo localectl set-locale LANG=en_US.UTF-8
# log "Locale set to en_US.UTF-8"
#
# if ! locale -a 2>/dev/null | grep -q "en_US.utf8"; then
#   sudo sed -i 's/^#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
#   sudo locale-gen
#   log "en_US.UTF-8 locale generated"
# fi

# =============================================================================
# 11. HOSTNAME
# =============================================================================
# header "Hostname"

# CURRENT_HOSTNAME=$(hostnamectl hostname 2>/dev/null || cat /etc/hostname)
# if [[ "$CURRENT_HOSTNAME" != "nixos" ]]; then
#   warn "NixOS config used hostname 'nixos'. Current: '$CURRENT_HOSTNAME'."
#   read -rp "  Change hostname to 'nixos'? (y/N): " change_host
#   if [[ "$change_host" =~ ^[Yy]$ ]]; then
#     sudo hostnamectl set-hostname nixos
#     log "Hostname set to nixos"
#   else
#     log "Keeping hostname: $CURRENT_HOSTNAME"
#   fi
# fi

# =============================================================================
# 12. USER GROUPS
# =============================================================================
header "User Groups"

CURRENT_USER="${SUDO_USER:-$USER}"
sudo usermod -aG networkmanager,wheel,audio,video,storage "$CURRENT_USER"
log "Added $CURRENT_USER to groups: networkmanager, wheel, audio, video, storage"

if ! sudo grep -q "^%wheel ALL=(ALL:ALL) ALL" /etc/sudoers; then
  echo "%wheel ALL=(ALL:ALL) ALL" | sudo tee -a /etc/sudoers > /dev/null
  log "Wheel group granted sudo access"
fi

# =============================================================================
# 13. GTK THEMING
# =============================================================================
header "GTK Settings"

mkdir -p "$HOME/.config/gtk-3.0"
if [[ ! -f "$HOME/.config/gtk-3.0/settings.ini" ]]; then
  cat > "$HOME/.config/gtk-3.0/settings.ini" <<EOF
[Settings]
gtk-icon-theme-name=Papirus
gtk-theme-name=Adwaita
gtk-font-name=Noto Sans 10
gtk-cursor-theme-name=Adwaita
EOF
  log "GTK3 settings written"
fi

mkdir -p "$HOME/.config/gtk-4.0"
if [[ ! -f "$HOME/.config/gtk-4.0/settings.ini" ]]; then
  cp "$HOME/.config/gtk-3.0/settings.ini" "$HOME/.config/gtk-4.0/settings.ini"
  log "GTK4 settings written"
fi

# =============================================================================
# DONE
# =============================================================================
header "Setup Complete!"

echo ""
echo -e "  ${GREEN}All packages installed and services configured.${NC}"
echo ""
echo "  Next steps:"
echo "   1. Reboot:              sudo reboot"
echo "   2. LightDM will start — select 'Sway' as your session"
echo "   3. Restore your sway/waybar/swaync dotfiles from backup"
echo "   4. Run 'nwg-look' to fine-tune GTK theming"
echo ""
echo "  Tips:"
echo "   - Night light: your wlsunset toggle will work out of the box"
echo "   - Screen sharing: Discord is patched for PipeWire — just works"
echo "   - Clipboard history: run 'wl-paste --watch clipman store &' in sway config"
echo "   - If audio doesn't work: systemctl --user status pipewire pipewire-pulse wireplumber"
echo ""
