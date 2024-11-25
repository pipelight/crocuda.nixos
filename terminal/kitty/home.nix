{
  config,
  cfg,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
  mkIf cfg.terminal.emulators.kitty.enable {
    home.file = {
      ".config/kitty/ssh.conf".source = dotfiles/kitty/ssh.conf;
    };

    # Terminal
    programs = {
      kitty = {
        enable = true;
        extraConfig = builtins.readFile dotfiles/kitty/kitty.conf;
        themeFile = "GitHub_Dark_Dimmed";
        # theme = "GitHub Dark Dimmed";
        # theme = "Doom One";
      };
    };
  }
