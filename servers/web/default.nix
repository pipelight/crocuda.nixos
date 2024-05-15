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
    ./unit.nix
    ./caddy.nix
  ];

  environment.defaultPackages = with pkgs; [
    # Vercel server anything
    nodePackages.serve
    # fail2ban
    pebble
  ];
      # SSL suport
      # security.acme = {
      #   acceptTerms = true;
      #   defaults.email = "admin+acme@example.org";
      # };

      # Open ports in the firewall.
      # networking.firewall.allowedTCPPorts = [ ... ];
}
