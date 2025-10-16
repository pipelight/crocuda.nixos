{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
with lib;
  mkIf config.crocuda.servers.security.enable {
    services.boulette = {
      enable = true;
      # enableFish = true;
      enableBash = true;
      sshOnly = false;
      enableSudoWrapper = true;
      challengeType = "hostname";
    };
  }
