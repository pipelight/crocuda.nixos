{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.crocuda.servers;
in
  with lib;
    mkIf cfg.dns.enable {
      environment.systemPackages = with pkgs; [
        dig
        ldns # provides "drill"
        unbound
        nsd
      ];
      environment.etc = {
      };
    }
