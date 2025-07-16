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
      services.virshle = {
        user = "anon";
        logLevel = "trace";
        enable = true;
      };
      environment.systemPackages = with pkgs; [
        # Build images based on flakes and local config
        nixos-generators
        rqlite
        disko
        cdrkit
      ];
      systemd.tmpfiles.rules = [
        "Z '/var/lib/crotui' 774 root users - -"
        "d '/var/lib/crotui' 774 root users - -"
      ];
    }
