{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in {
  imports = [
    ./jucenit.nix
    ./ssl-test.nix
    ./sozu.nix
  ];

  environment.defaultPackages = with pkgs; [
    # Vercel server anything
    nodePackages.serve
    # fail2ban
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
}
