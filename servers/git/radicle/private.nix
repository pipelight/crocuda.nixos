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
      environment.systemPackages = with pkgs; [
        radicle-explorer
        radicle-tui
      ];

      services.radicle = {
        enable = true;
        checkConfig = true;

        privateKeyFile = "/etc/radicle/id_ed25519";
        # privateKeyFile = "/var/lib/radicle/keys/radicle";

        # publicKey = "/etc/radicle/id_ed25519.pub";
        # publicKey = "/var/lib/radicle/keys/radicle.pub";
        publicKey = /etc/radicle/id_ed25519.pub;

        node = {
          listenAddress = "[::1]";
          listenPort = 8776;
        };
        httpd = {
          enable = true;
          listenAddress = "[::1]";
          listenPort = 8786;
        };
        settings = {
          "node" = {
            "alias" = "anon";
            "externalAddresses" = [
              (config.networking.hostName + ".lan" + ":8776")
            ];
          };
        };
      };
    }
