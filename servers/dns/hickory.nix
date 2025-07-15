{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: let
  cfg = config.crocuda;
  keaDDnsEnabled = config.services.kea.dhcp-ddns.enable;
  hickory-dns-latest = import ./hickory.latest.nix;

  base = pkgs.writeText "/var/lib/hickory-dns/vm.zone" ''
    ; SOA record
    @ IN SOA a.ns admin (
      1999010100 ; serial
      10800 ; refresh (3 hours)
      900 ; retry (15 minutes)
      604800 ; expire (1 week)
      86400 ; minimum (1 day)
    )
  '';
in {
  ## dns resolver/caching
  systemd.tmpfiles.rules = [
    "Z '/var/lib/hickory-dns' 764 root users - -"
    "Z '/var/run/hickory-dns' 764 root users - -"

    "f '/var/lib/hickory-dns/vm.zone' 764 root users - -"
  ];
  environment.systemPackages = [
    # pkgs-unstable.hickory-dns
    hickory-dns-latest
  ];

  services.hickory-dns = {
    debug = true;
    # package = pkgs-unstable.hickory-dns;
    package = hickory-dns-latest;
    settings = {
      listen_addrs_ipv4 = ["127.0.0.1"];
      listen_addrs_ipv6 = ["::1"];
      listen_port = 53;
      zones = let
        baseConfig = {
          trust_negative_responses = false;

          connections = [
            {protocol = {type = "udp";};}
            {protocol = {type = "tcp";};}
          ];
        };
      in [
        {
          zone = "vm";
          zone_type = "Primary";
          # stores = {type = "sqlite";};
        }
        {
          zone = "lan";
          zone_type = "External";
          stores = [
            {
              type = "forward";
              name_servers = [
                {
                  http_endpoint = "192.168.1.1";
                  inherit (baseConfig) trust_negative_responses;
                }
                {
                  http_endpoint = "fe80::e0b0:beff:feb0:beb0";
                  inherit (baseConfig) trust_negative_responses;
                }
              ];
            }
          ];
        }
        {
          zone = ".";
          zone_type = "External";
          stores = [
            {
              type = "forward";
              name_servers = [
                #Mullvad
                {
                  http_endpoint = "194.242.2.4";
                  inherit (baseConfig) trust_negative_responses;
                }
                {
                  http_endpoint = "2a07:e340::4";
                  inherit (baseConfig) trust_negative_responses;
                }
                #Quad9
                {
                  http_endpoint = "9.9.9.9";
                  inherit (baseConfig) trust_negative_responses;
                }
                {
                  http_endpoint = "2620:fe::fe";
                  inherit (baseConfig) trust_negative_responses;
                }
              ];
            }
          ];
        }
      ];
    };
  };
  systemd.services.hickory-dns = with lib; {
    serviceConfig = {
      ExecStartPost = [
        # "-${pkgs.coreutils}/bin/chmod -R 7660 /var/lib/kea"
        "-${pkgs.coreutils}/bin/chmod -R g+r /var/lib/hickory-dns"
        "-${pkgs.coreutils}/bin/chmod -R g+w /var/lib/hickory-dns"
      ];
      User = mkForce "root";
      Group = "users";
      UMask = mkForce "0007";
      DynamicUser = mkForce false;
    };
  };
}
