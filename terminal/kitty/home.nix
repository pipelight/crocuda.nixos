{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  home.file = {
    ".config/kitty/ssh.conf".source = dotfiles/kitty/ssh.conf;
  };

  # Terminal
  programs = {
    kitty = {
      enable = true;
      extraConfig = builtins.readFile dotfiles/kitty/kitty.conf;
      theme = "GitHub Dark Dimmed";
      # theme = "Doom One";
    };
  };
}
