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
    mkIf cfg.servers.web.jucenit.enable {
      services.jucenit.enable = true;
    }
