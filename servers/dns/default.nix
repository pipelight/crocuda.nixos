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
        dig
        # ldns # provides "drill"
        unbound
        nsd
        bind
      ];
    }
