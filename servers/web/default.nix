{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in {
  environment.defaultPackages = with pkgs; [
    # Vercel server anything
    nodePackages.serve
    # fail2ban
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
}
