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
  odhcpd = pkgs.fetchgit {
    url = "git://git.openwrt.org/project/odhcpd.git";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };
in
  with lib;
    mkIf cfg.virtualization.virshle.enable {
      ## DhcpV6
    }
