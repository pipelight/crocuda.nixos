{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.crocuda;
in
  with lib;
    mkIf cfg.servers.atuin.enable {
      services.atuin = {
        enable = true;
      };
    }
