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
    mkIf cfg.virtualization.docker.enable {

      # Enable docker usage
      virtualisation.docker.enable = true;
      virtualisation.podman.enable = true;

      users.groups = let
        users = cfg.users;
      in {
        docker.members = users;
      };
    }
