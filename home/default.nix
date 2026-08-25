{ config, pkgs, ... }:

{
  home.username = "alice";
  home.homeDirectory = "/home/alice";
  home.stateVersion = "23.11";

  # All your packages in one place
  home.packages = with pkgs; [
    neovim
    tmux
    ripgrep
    fd
    fzf
    git
    htop
    nodejs
    rustup
  ];

  # OR generate dotfiles from Nix config (better!)
  programs.git = {
    enable = true;
    userName = "Hamzah004";
    userEmail = "hamzahbaniata75@gmail.com";
    extraConfig = {
      core.editor = "nvim";
      push.default = "current";
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraConfig = builtins.readFile ./dotfiles/nvim/init.lua;
  };

  # programs.tmux = {
  #   enable = true;
  #   shell = "${pkgs.zsh}/bin/zsh";
  #   extraConfig = ''
  #     set -g prefix C-a
  #     bind C-a send-prefix
  #   '';
  # };
  #
  # programs.zsh = {
  #   enable = true;
  #   oh-my-zsh.enable = true;
  #   shellAliases = {
  #     ll = "ls -lah";
  #     gs = "git status";
  #     ga = "git add";
  #   };
  # };
}
