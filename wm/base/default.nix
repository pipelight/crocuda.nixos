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
      # User specific
      home-merger = {
        enable = true;
        extraSpecialArgs = {inherit pkgs;};
        users = cfg.users;
        modules = [
          ./home.nix
        ];
      };

      ## Video /Sound
      programs.light.enable = true;
      # Disable old software
      sound.enable = false;
      hardware.pulseaudio.enable = false;
      # Enable new software
      security.rtkit.enable = true;
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

      home.file = {
        ".profile".source = dotfiles/.profile;
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
