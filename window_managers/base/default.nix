{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in
  with lib;
    mkIf (cfg.wm.hyprland.enable
      || cfg.wm.niri.enable) {
      environment.sessionVariables = {
        XDG_BACKGROUND = "$HOME/Pictures/Backgrounds/goku_minimal_orange.png";
      };

      programs.light.enable = true;
      security.rtkit.enable = true;

      ## Sound
      services.pulseaudio.enable = false;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      users.groups = {
        audio.members = cfg.users;
        video.members = cfg.users;
        # Swhkd
        input.members = cfg.users;
      };

      # Swhkd
      # No longer need to be root.
      # Members of the input group can interact with keyboard.
      systemd.tmpfiles.rules = [
        "z /dev/input 0775 root input - -"
        "z /dev/uinput 0660 root input - -"
      ];

      environment.systemPackages = with pkgs; [
        # pactl audio control cli
        xdg-utils
        pulseaudio
        pamixer
      ];

      ###################################
      # Fonts
      fonts = {
        fontconfig = {
          defaultFonts = rec {
            emoji = ["Noto Color Emoli"];
            monospace = [
              "JetBrains Mono Nerd Font Mono"
              "JetBrains Mono NL Nerd Font Mono"
              "NotoSansM Nerd Font Mono"
              "Noto Sans Mono CJK JP"
            ];
            sansSerif = monospace;
            serif = monospace;
          };
        };
        packages = with pkgs; [
          #24.11
          # (nerdfonts.override {
          #   fonts = [
          #     "JetBrainsMono"
          #     "Noto"
          #   ];
          # })

          #25.05
          nerd-fonts.jetbrains-mono
          nerd-fonts.noto

          noto-fonts-color-emoji
          noto-fonts-cjk-sans
        ];
      };
    }
