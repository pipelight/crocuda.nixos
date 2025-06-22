{
  config,
  pkgs,
  pkgs-unstable,
  pkgs-stable,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in
  with lib;
    mkIf cfg.virtualization.virshle.enable {
      ## DhcpV6
      environment.systemPackages = with pkgs; [
        # dnsmasq
        kea
      ];

      systemd.services.kea-dhcp6-server = {
        serviceConfig = {
          User = mkForce "root";
          Group = "users";
          UMask = mkForce "0007";

          # Do not store tmp files in private dir.
          DynamicUser = mkForce false;
          # Set file permissions
          ExecStartPost = [
            # "-${pkgs.coreutils}/bin/chmod -R 7660 /var/lib/kea"
            "-${pkgs.coreutils}/bin/chmod -R g+r /var/lib/kea"
            "-${pkgs.coreutils}/bin/chmod -R g+w /var/lib/kea"
          ];
        };
      };

      services.kea = {
        dhcp4.enable = false;
        dhcp6 = {
          enable = true;
          settings = {
            #Json
            interfaces-config = {
              interfaces = mkDefault [
                "br0-dhcp"
              ];
              service-sockets-max-retries = 1000;
              service-sockets-retry-wait-time = 5000;
              # service-sockets-require-all = true;
              re-detect = true;
            };
            lease-database = {
              name = "/var/lib/kea/dhcp6.leases";
              persist = true;
              type = "memfile";
            };
            rebind-timer = 2000;
            renew-timer = 1000;
            preferred-lifetime = 3000;
            valid-lifetime = 4000;
          };
        };
      };
    }
