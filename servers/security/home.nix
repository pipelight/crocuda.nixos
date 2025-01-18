{
  inputs,
  config,
  cfg,
  pkgs,
  lib,
  ...
}:
with lib;
  mkIf cfg.servers.security.enable {
    services.boulette = {
      enable = true;
      enableFish = true;
      enableBash = true;
      sshOnly = false;
      enableSudoWrapper = true;
      challengeType = "hostname";
    };
  }
