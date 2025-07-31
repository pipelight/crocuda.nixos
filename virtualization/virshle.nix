{
  config,
  pkgs,
  pkgs-unstable,
  pkgs-stable,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in
  with lib;
    mkIf cfg.virtualization.virshle.enable {
      # environment.etc = {
      #   "virshle/config.toml".text = builtins.readFile ./dotfiles/virshle/config.toml;
      # };

      services.virshle = {
        enable = true;
        logLevel = "debug";
        user = "anon";
      };
      environment.systemPackages = with pkgs; [
        # Build images based on flakes and local config
        nixos-generators
        rqlite
        disko
        cdrkit
      ];
    }
