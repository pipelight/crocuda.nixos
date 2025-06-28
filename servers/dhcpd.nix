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

      systemd.services.kea-dhcp4-server = {
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
        dhcp4 = {
          settings = {
            interfaces-config = {
              interfaces = mkDefault [
                "br0-dhcp"
              ];
              # service-sockets-max-retries = 5;
              # service-sockets-retry-wait-time = 5000;
              # re-detect = true;
            };
            lease-database = {
              name = "/var/lib/kea/dhcp4.leases";
              persist = true;
              type = "memfile";
            };
            rebind-timer = 500;
            renew-timer = 100;
            valid-lifetime = 1000;
          };
        };

        dhcp6 = {
          settings = {
            #Json
            interfaces-config = {
              interfaces = mkDefault [
                "br0-dhcp"
              ];
              # service-sockets-max-retries = 5;
              # service-sockets-retry-wait-time = 5000;
              # re-detect = true;
            };
            lease-database = {
              name = "/var/lib/kea/dhcp6.leases";
              persist = true;
              type = "memfile";
            };
            rebind-timer = 500;
            renew-timer = 100;
            preferred-lifetime = -1;
            valid-lifetime = -1;
          };
        };
      };
    }
