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
    ./dns/default.nix
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
  environment.systemPackages = with pkgs; [
    # openssl
  ];

  services.openssh = {
    enable = cfg.ssh.enable;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.Macs = [
      # rust libssh2 compat
      "hmac-sha2-256"
      "hmac-sha2-512"
      # default
      "hmac-sha2-512-etm@openssh.com"
      "hmac-sha2-256-etm@openssh.com"
      "umac-128-etm@openssh.com"
    ];
    # settings.PermitRootLogin = "yes";
  };
}
