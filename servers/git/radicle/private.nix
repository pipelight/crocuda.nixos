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
        checkConfig = true;
        privateKeyFile = "/etc/radicle/id_ed25519";
        publicKey = "/etc/radicle/id_ed25519.pub";
        node = {
          listenAddress = "::1";
          listenPort = 8776;
        };
        httpd = {
          enable = true;
          listenAddress = "::1";
          listenPort = 8786;
        };
        settings = {
          "node" = {
            "alias" = "anon";
            "externalAddresses" = ["seed.example.com:8776"];
            "policy" = "allow";
            "scope" = "all";
          };
        };
      };
    }
