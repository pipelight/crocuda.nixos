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
        host = "127.0.0.1";
        port = 8182;
      };

      crocuda.servers.web.sozu.config = mkAfter {
        clusters = {
          atuin = {
            protocol = "http";
            https_redirect = false;
            frontends = [
              {
                address = "[::]:8181";
                hostname = config.networking.hostName;
              }
              {
                address = "0.0.0.0:8181";
                hostname = config.networking.hostName;
              }
            ];
            backends = [
              {
                address = "127.0.0.1:8182";
              }
            ];
          };
        };
      };
    }
