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
    mkIf cfg.wm.hyprland.enable {
      programs.light.enable = true;

      security.rtkit.enable = true;

      ## Sound
      hardware.pulseaudio.enable = false;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      users.groups = {
        audio.members = cfg.users;
        video.members = cfg.users;
      };

      environment.systemPackages = with pkgs; [
        # pactl audio control cli
        pulseaudio
        pamixer
      ];

      # Fonts
      fonts = {
        fontconfig = {
          defaultFonts = {
            monospace = ["JetBrainsMonoNL Nerd Font"];
            sansSerif = ["JetBrainsMonoNL Nerd Font"];
            serif = ["JetBrainsMonoNL Nerd Font"];
          };
        };
        packages = with pkgs; [
          (nerdfonts.override {
            fonts = [
              "FiraCode"
              "JetBrainsMono"
              "DroidSansMono"
            ];
          })
        ];
      };
    }
