################################
## Printer and Scanner
# This module adds the bare minimum for scanner compatibility.
# Support only Epson backend but can be extended if requested.
{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.crocuda;
in
  with lib;
    mkIf cfg.office.printers.enable {
      environment.systemPackages = with pkgs; [
        ## Gnome Gui for scanners
        simple-scan
      ];
      # Allow unfree software
      allow-unfree = [
        # Epson scanner
        "iscan"
        "iscan-.*"
      ];
      ## Printers
      # Enable CUPS to handle printers
      services.printing = {
        enable = true;
        drivers = with pkgs; [
          epson-escpr
          #or
          epson-escpr2
        ];
      };
      services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
      ## Scanners
      # Enable SANE to handle scanners
      hardware.sane.enable = true;
      # Epson support
      hardware.sane.extraBackends = [pkgs.epkowa];
      users.groups = {
        scanner.members = cfg.users;
        lp.members = cfg.users;
      };
    }
