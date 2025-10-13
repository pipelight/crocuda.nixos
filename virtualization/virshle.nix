{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.crocuda;
in
  with lib;
    mkIf config.crocuda.virtualization.virshle.enable {
      # environment.etc = {
      #   "virshle/config.toml".text = builtins.readFile ./dotfiles/virshle/config.toml;
      # };

      services.virshle = {
        enable = true;
        logLevel = "debug";
        user = "anon";
        dhcp.defaultConfig = true;
      };

      environment.systemPackages = with pkgs; [
        # Build images based on flakes and local config
        nixos-generators
        rqlite
        disko
        cdrkit
      ];
    }
