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
  ];
  ################################
  # Ssh
  services.openssh = {
    enable = cfg.ssh.enable;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    # settings.PermitRootLogin = "yes";
  };
}
