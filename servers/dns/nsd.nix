{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
  dnslib = import ./lib.nix;

  unboundEnabled = config.services.unbound.enable;
in
  with lib;
    mkIf cfg.servers.dns.enable {
      services = {
        nsd = {
          enable = true;

          verbosity = 2;
          # extraConfig = ''
          #   server:
          #     hide-identity: yes
          #     hide-version: yes
          # '';

          port =
            if unboundEnabled
            # Run on non default port if unbound is already running
            then 553
            # Listen on default port
            else 53;
          interfaces =
            if unboundEnabled
            # Listen on localhost only if unbound is already running.
            then ["127.0.0.1" "::1"]
            # Listen on public
            else ["0.0.0.0" "::0"];

          zones = with dnslib;
            {}
            // mkDefaultZone {
              domain = "crocuda.com";
              ipv4 = "95.164.16.172";
              ipv6 = null;
            }
            // mkDefaultZone {
              domain = "pipelight.dev";
              ipv4 = "95.164.16.172";
              ipv6 = null;
            }
            // mkDefaultZone {
              domain = "areskul.com";
              ipv4 = "95.164.16.172";
              ipv6 = null;
            };
        };
      };
    }
