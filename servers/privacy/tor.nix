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
    mkIf cfg.server.privacy.tor {
      environment.systemPackages = with pkgs; [
        # Tor
        torsocks
      ];
    }
