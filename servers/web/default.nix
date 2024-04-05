{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in {
  users.groups = {
    unit.members = cfg.users;
  };

  environment.defaultPackages = with pkgs; [
    # Crocuda dependencies
    caddy
    nodePackages.serve

    openssl
    unit
    deno
    certbot
    # fail2ban
  ];
}
