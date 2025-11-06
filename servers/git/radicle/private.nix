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
        # privateKeyFile = "/var/lib/radicle/keys/radicle";

        # publicKey = "/etc/radicle/id_ed25519.pub";
        # publicKey = "/var/lib/radicle/keys/radicle.pub";
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPUZIvo0RPhao7s73Wt613qJw/P+KseGEnqA7/gT/AYx";

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
