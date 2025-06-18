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
        # package = pkgs-unstable.hyprland;
        package = pkgs-deprecated.hyprland;
        # package = pkgs.hyprland.override {
        #   debug = true;
        # };
        # package = inputs.hyprland.packages.${pkgs.system}.hyprland;

        plugins = with pkgs-deprecated.hyprlandPlugins; [
          # plugins = with pkgs-unstable.hyprlandPlugins; [
          hyprscroller
          hyprbars
          # inputs.hyprscroller.packages.${pkgs.system}.default
          # inputs.hyprfocus.packages.${pkgs.system}.default
        ];
        extraConfig = lib.readFile dotfiles/hypr/hyprland.conf;
      };

      home.sessionVariables = {
        # env = AQ_NO_MODIFIERS = 1;
        # AQ_NO_ATOMIC = 1;
        # AQ_DRM_DEVICES = "/dev/dri/card1";
      };

      home.packages = with pkgs; [
        # Screenshots
        hyprshot

        # Yofi and dependencies
        inputs.yofi.packages.${system}.default

        # Font support
        libnotify
        fontconfig

        # Wallpapers
        convert_to_grayscale
        pkgs-stable.swww
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
