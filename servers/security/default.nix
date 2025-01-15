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
    mkIf cfg.servers.security.enable {
      services.boulette = {
        enable = true;
        enableFish = true;
        enableBash = true;
        sshOnly = true;
        enableSudoWrapper = true;
        challengeType = "hostname";
      };
    }
