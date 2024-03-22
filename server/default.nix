{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in {
  ################################
  # Ssh
  services.openssh = {
    enable = cfg.servers.ssh.enable;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    # settings.PermitRootLogin = "yes";
  };

  environment.systemPackages = with pkgs; [
    # Decentralized code collaboration plateform
    radicle-cli
  ];
}
