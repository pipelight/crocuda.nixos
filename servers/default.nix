{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda.servers;
in {
  imports = [
    ./git/default.nix
    ./web/default.nix
    ./mail/default.nix
    ./social/default.nix
  ];
  ################################
  # Ssh
  #
  # Caution:
  # This service internally modify the firewall to
  # allow tcp and udp on the specified ports.
  #
  services.openssh = {
    enable = cfg.ssh.enable;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    # settings.PermitRootLogin = "yes";
  };
}
