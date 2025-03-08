{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.crocuda;
in
  with lib;
    mkIf cfg.servers.dns.enable {
      environment.systemPackages = with pkgs; [
        # ldns # provides "drill"

        # Already side loaded by nix config
        # unbound
        # nsd
      ];
    }
