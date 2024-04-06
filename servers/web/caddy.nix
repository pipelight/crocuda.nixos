{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
  # A dedicated unpriviledged user for public node
  username = "caddy";
in
  with lib;
    mkIf cfg.servers.web.caddy.enable {
      users.users."${username}" = {
        isSystemUser = true;
        homeMode = "770";
      };
      services.caddy = {
        enable = true;
        user = username;
        group = "users";
        acmeCA = "https://acme-staging-v02.api.letsencrypt.org/directory";
      };
    }
