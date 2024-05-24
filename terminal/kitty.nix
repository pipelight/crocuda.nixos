{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  home.file = {
    ".config/pacman/makepkg.conf".source = dotfiles/pacman/makepkg.conf;
    ".config/kitty/ssh.conf".source = dotfiles/kitty/ssh.conf;
  };

  home.packages = with pkgs; [
    # tmux
    zellij
    # Packaging for AUR
    pacman
  ];

  # Shell
  programs = {
    # Terminal
    kitty = {
      enable = true;
      extraConfig = builtins.readFile dotfiles/kitty/kitty.conf;
      theme = "GitHub Dark Dimmed";
    };
  };
}
