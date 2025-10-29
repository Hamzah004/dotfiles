# ~/.config/fish/config.fish

# Only run if interactive shell (Fish is always interactive, but this is for safety)

# set greeting off
set -U fish_greeting ""

if not status --is-interactive
    return
end

# History settings
# Fish uses a different history mechanism but you can set history limits here:
set -U fish_history_limit 2000  # similar to HISTFILESIZE
# Note: Fish automatically appends history; no need to set append mode.

# Check window size - Fish does this automatically

# Debian chroot detection for prompt
if test -z "$debian_chroot" -a -r /etc/debian_chroot
    set -gx debian_chroot (cat /etc/debian_chroot)
end

# Prompt with color support - Fish uses functions to define prompt
function fish_prompt
    set_color normal
    if test -n "$debian_chroot"
        echo -n "($debian_chroot) "
    end
    set_color green
    echo -n (whoami) "@" (hostname|cut -d . -f 1)
    set_color normal
    echo -n ":"
    set_color blue
    echo -n (prompt_pwd)
    set_color normal
    # echo -n " $ "
end

# Set terminal title for xterm and rxvt-like terminals
if string match -qr '^(xterm|rxvt)' $TERM
    function fish_title
        echo -n (whoami) "@" (hostname|cut -d . -f 1) ": " (prompt_pwd)
    end
end

# Enable color support for ls using dircolors if available
if test -x /usr/bin/dircolors
    if test -r ~/.dircolors
        eval (dircolors -c ~/.dircolors)
    else
        eval (dircolors -c)
    end
    alias ls 'ls --color=auto'
    # other aliases commented out in original; enable if wanted:
    # alias grep 'grep --color=auto'
    # alias fgrep 'fgrep --color=auto'
    # alias egrep 'egrep --color=auto'
end

# Add flutter to PATH if not already included
if not contains $HOME/development/flutter/bin $PATH
    set -gx PATH $HOME/development/flutter/bin $PATH
end

# Add ~/bin to PATH if not already included
if not contains $HOME/bin $PATH
    set -gx PATH $HOME/bin $PATH
end

# Add Go lang binary path if not included
if not contains /usr/local/go/bin $PATH
    set -gx PATH $PATH /usr/local/go/bin
end

# Add Rust/Cargo to PATH if exists
if test -d $HOME/.cargo/bin
    if not contains $HOME/.cargo/bin $PATH
        set -gx PATH $HOME/.cargo/bin $PATH
    end
end

# Starship prompt init
if test -x $HOME/.cargo/bin/starship
    eval ($HOME/.cargo/bin/starship init fish)
    set -gx STARSHIP_CONFIG $HOME/starship/starship.toml
end

# # Set default editor to nvim
# set -gx EDITOR nvim
# set -gx VISUAL nvim

# Aliases
alias brightup='brightnessctl set +5%'
alias brightdown='brightnessctl set 5%-'
alias rm='trash-put'

# bat (better cat)
alias bat='/usr/bin/bat'

# eza (better ls) and ls aliases
alias ls='eza --icons=always'
alias ll='ls -l'
alias la='ls -A'
alias lsa='ls --icons=always --all'
alias lslsg='ls --long -G --total-size --icons=always -i'
alias lslsga='ls --long -G --total-size --icons=always --all -i'
alias lsls='ls --long --total-size --icons=always -i'
alias lslsa='ls --long --total-size --icons=always --all -i'

# Zoxide (better cd)
if command -q zoxide
    eval (zoxide init fish)
    alias cd='z'
    alias cdf='zi'
end

# Clear shortcut
alias c='clear'

# Manage dotfiles alias
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Quick exit alias
alias q='exit'

# w3m alias commented out (optional)
# alias w3m='w3m duckduckgo.com'

# Set MANPAGER with bat for nicer man pages (like your bashrc)
set -gx MANPAGER "sh -c 'sed -u -e \"s/\\x1B\\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"

# Source local environment variables if file exists
if test -f $HOME/.local/bin/env
    source $HOME/.local/bin/env
end
fastfetch
