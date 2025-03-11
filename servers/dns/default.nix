{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
  dns = inputs.dns.lib;

  mkDefaultZone = domain: ipv4: ipv6:
    with dns.combinators;
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
in
  with lib;
    mkIf cfg.servers.dns.enable {
      services = {
        nsd = {
          hideVersion = true;
          enable = true;
          interfaces = ["0.0.0.0" "::0"];
          ipv4 = true;
          ipv6 = true;
          verbosity = 2;
          zones =
            {}
            // makeDefaultZone "crocuda.com" null "95.164.16.172";
        };
      };
    }
