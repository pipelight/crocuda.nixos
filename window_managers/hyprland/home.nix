{
  config,
  cfg,
  pkgs,
  pkgs-stable,
  pkgs-unstable,
  pkgs-deprecated,
  lib,
  inputs,
  ...
}: let
  convert_to_grayscale = pkgs.writeShellScriptBin "convert_to_grayscale" ''
    convert $1 -colorspace gray $1.gray.jpeg
  '';
in
  with lib;
    mkIf cfg.wm.hyprland.enable {
      ## Plugins
      wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;
        package = pkgs-stable.hyprland;
        # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
        plugins = with pkgs-stable.hyprlandPlugins; [
          hyprscroller

          # inputs.hyprscroller.packages.${pkgs.system}.default
          # inputs.hyprfocus.packages.${pkgs.system}.default
        ];
        extraConfig = lib.readFile dotfiles/hypr/hyprland.conf;
      };

      home.packages = with pkgs; [
        # Yofi and dependencies
        inputs.yofi.packages.${system}.default

        # Font support
        libnotify
        fontconfig

        # Wallpapers
        # Wallpapers
        convert_to_grayscale
        swww
        # toolbars
        eww
        # utils
        wev
        # notifications
        dunst
      ];

      home.file = {
        # Notifications
        ".config/dunst/dunstrc".source = dotfiles/dunstrc;

        ## Hyprland specific
        # Utils functions
        ".config/hypr/utils".source = dotfiles/hypr/utils;

        # Keyindings
        ".config/hypr/binds".source = dotfiles/hypr/binds;
        ".config/hypr/ratios".source = dotfiles/hypr/ratios;

        ".config/hypr/rules.conf".source = dotfiles/hypr/rules.conf;
        ".config/hypr/theme.conf".source = dotfiles/hypr/theme.conf;
        # ".config/hypr/hyprland.conf".source = dotfiles/hypr/hyprland.conf;

        # Widgets
        ".config/eww".source = dotfiles/eww;
        ".config/yofi".source = dotfiles/yofi;
      };

      # Default keybindings
      systemd.user.tmpfiles.rules = with lib;
        [
          "L+ %h/.config/hypr/binds.conf - - - - %h/.config/hypr/binds/${cfg.keyboard.layout}.${cfg.wm.hyprland.mode}.conf"
        ]
        ++ [
          (mkIf (cfg.wm.hyprland.wide)
            "L+ %h/.config/hypr/ratio.conf - - - - %h/.config/hypr/ratios/32_9.conf")
          (mkIf (!cfg.wm.hyprland.wide)
            "L+ %h/.config/hypr/ratio.conf - - - - %h/.config/hypr/ratios/16_9.conf")
        ];
    }
