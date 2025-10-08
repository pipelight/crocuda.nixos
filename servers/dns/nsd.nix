{
  crocuda_lib,
  config,
  lib,
  inputs,
  ...
}: let
  unboundEnabled = config.services.unbound.enable;
in
  with lib;
    mkIf config.crocuda.servers.dns.enable {
      services = {
        nsd = {
          # zonefilesCheck = false;
          verbosity = 4;
          extraConfig = ''
            server:
              hide-identity: yes
              hide-version: yes
          '';
          port =
            if unboundEnabled
            # Run on non default port if unbound is already running
            then 53020
            # Listen on default port
            else 53;

          interfaces =
            if unboundEnabled
            # Listen on localhost only if unbound is already running.
            then ["127.0.0.1" "::1"]
            # Listen on public
            else ["0.0.0.0" "::0"];

          zones = with crocuda_lib.dns;
            {}
            // mkDefaultZone {
              domain = "vm";
              ipv4 = null;
              ipv6 = null;
            };
        };
      };
    }
