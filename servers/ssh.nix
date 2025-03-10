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
  #
  # Caution:
  # This service internally modify the firewall to
  # allow tcp and udp on the specified ports.
  #

  # Enable the agent
  programs.ssh.startAgent = true;

  services.openssh = {
    enable = lib.mkDefault cfg.servers.ssh.enable;
    # require public key authentication for better security
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      Macs = [
        # rust libssh2 compat
        "hmac-sha2-256"
        "hmac-sha2-512"
        # default
        "hmac-sha2-512-etm@openssh.com"
        "hmac-sha2-256-etm@openssh.com"
        "umac-128-etm@openssh.com"
      ];
    };

    # settings.PermitRootLogin = "yes";
  };
}
