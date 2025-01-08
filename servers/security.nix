{
  config,
  pkgs,
  pkgs-stable,
  lib,
  ...
}: let
  cfg = config.crocuda;
in
  with lib;
    mkIf cfg.servers.security.enable {
      environment.systemPackages = with pkgs-stable; [
        # molly-guard
      ];
    }
