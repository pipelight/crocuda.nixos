{
  config,
  cfg,
  pkgs,
  lib,
  ...
}: let
  rofi = pkgs.fetchFromGitHub {
    owner = "adi1090x";
    repo = "rofi";
    rev = "refs/heads/master";
    hash = "sha256-YjyrxappcLDoh3++mtZqCyxQV2qeoNhhUy2XGwlyTng=";
  };
in
  with lib;
    mkIf cfg.wm.bspwm.enable {
      home.file = {
        # Xorg
        ".xinitrc".source = dotfiles/.xinitrc;
        ".xsession".source = dotfiles/.xinitrc;

        # Set tilling window manager user config
        ".config/bspwm/bspwmrc".source = dotfiles/bspwmrc;
        ".config/sxhkd/sxhkdrc".source = dotfiles/sxhkdrc;

        # Eww Bar
        # ".config/eww".source = dotfiles/eww;
        # Rofi
        # ".config/rofi".source = rofi + "/files";
      };
    }
