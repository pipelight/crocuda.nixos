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
    mkIf cfg.servers.git.radicle.enable {
      services.radicle = {
        enable = true;
        # privateKeyFile = /etc/radicle/;
        # publicKey = /etc/radicle/;
        settings = {};
      };
    }
