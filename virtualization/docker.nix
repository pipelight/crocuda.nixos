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
      environment.systemPackages = with pkgs; [
        docker
      ];

      users.groups = let
        users = cfg.users;
      in {
        docker.members = users;
      };
    }