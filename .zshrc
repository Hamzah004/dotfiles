# ~/.zshrc: interactive Zsh config with modern features and starship prompt

# Only run if interactive shell
[[ $- != *i* ]] && return

# --- History settings ---
setopt HIST_IGNORE_SPACE     # ignore commands starting with space
setopt HIST_IGNORE_DUPS      # ignore duplicate commands
setopt HIST_APPEND           # append to history file, don't overwrite
setopt SHARE_HISTORY         # share history between sessions
HISTSIZE=1000
SAVEHIST=2000
HISTFILE=~/.zsh_history

# --- Window size ---
autoload -Uz add-zsh-hook
add-zsh-hook precmd () { emulate -L zsh; zle && zle reset-prompt }
TRAPWINCH() { emulate -L zsh; zle && zle reset-prompt }

# --- Extended globbing ---
setopt EXTENDED_GLOB

# --- Chroot prompt ---
if [[ -z "$debian_chroot" && -r /etc/debian_chroot ]]; then
  debian_chroot=$(< /etc/debian_chroot)
fi

# --- Colors for prompt ---
autoload -Uz colors && colors

# --- Terminal title ---
case "$TERM" in
  xterm*|rxvt*)
    precmd() {
      print -Pn "\e]0;${debian_chroot:+($debian_chroot)}%n@%m: %~\a"
    }
    ;;
esac

# --- Starship prompt init ---
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
  export STARSHIP_CONFIG="$HOME/starship/starship.toml"
fi

# --- Plugins disabled ---
# Uncomment to re-enable if needed:
# source ~/.config/zsh/zsh-autosuggestions.zsh
# source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --- Editor ---
export EDITOR='nvim'
export VISUAL='nvim'

# --- vi mode ---
bindkey -v

# --- PATH additions ---
if [[ ":$PATH:" != *":$HOME/development/flutter/bin:"* ]]; then
  export PATH="$HOME/development/flutter/bin:$PATH"
fi

if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
  export PATH="$HOME/bin:$PATH"
fi

if [[ ":$PATH:" != *":/usr/local/go/bin:"* ]]; then
  export PATH="/usr/local/go/bin:$PATH"
fi

# --- Rust toolchain env ---
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# --- Zoxide init ---
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# --- Aliases ---
# alias ls='eza --icons=always'
# alias ll='ls -l'
# alias la='ls -A'
# alias lsa='ls --icons=always --all'
# alias lslsg='ls --long -G --total-size --icons=always -i'
# alias lslsga='ls --long -G --total-size --icons=always --all -i'
# alias lsls='ls --long --total-size --icons=always -i'
# alias lslsa='ls --long --total-size --icons=always --all -i'

alias brightup="brightnessctl set +5%"
alias brightdown="brightnessctl set 5%-"
alias rm="trash-put"
alias bat="/usr/bin/bat"

alias cd="z"
alias cdf="zi"

alias c="clear"
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias q="exit"

# --- Man pages with bat ---
export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"

# --- Custom env file ---
[[ -f "$HOME/.local/bin/env" ]] && source "$HOME/.local/bin/env"

# alias francinette=/home/liva/francinette/tester.sh

# alias paco=/home/liva/francinette/tester.sh
# Source the Lazyman shell initialization for aliases and nvims selector
# shellcheck source=.config/nvim-Lazyman/.lazymanrc
# [ -f ~/.config/nvim-Lazyman/.lazymanrc ] && source ~/.config/nvim-Lazyman/.lazymanrc
# Lazyman nvimsbind disabled due to bind command errors
# [ -f ~/.config/nvim-Lazyman/.nvimsbind ] && source ~/.config/nvim-Lazyman/.nvimsbind
