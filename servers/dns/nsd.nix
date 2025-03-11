{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
  dns = inputs.dns.lib;

  unboundEnabled = config.services.unbound.enable;

  mkDefaultZone = domain: ipv4: ipv6:
    with dns.combinators; let
      data =
        {
          useOrigin = true;
          SOA = {
            nameServer = "ns1";
            adminEmail = "admin@${domain}";
            serial = 60 * 365 * 24 * 60 * 60;
          };
        }
        // {
          NS = [
            "ns1.${domain}."
            "ns2.${domain}."
          ];
        }
        // host ipv4 ipv6
        // {
          # Mail server autodiscovery
          SRV = [
            {
              service = "autodiscovery";
              proto = "tcp";
              port = "443";
              target = "autoconfig";
            }
          ];
        };
    in {"${domain}" = data;};
in
  with lib;
    mkIf cfg.servers.dns.enable {
      services = {
        nsd = {
          enable = true;

          hide-version = true;
          hide-identity = true;
          verbosity = 2;

          interfaces =
            if unboundEnabled
            # Listen on localhost only
            # and unbound will forward the dns zones
            then ["127.0.0.1" "::1"]
            # Listen on public
            else ["0.0.0.0" "::0"];

          zones = {};
          # // mkDefaultZone "crocuda.com" null "95.164.16.172";
        };
      };
    }
