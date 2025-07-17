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
  nsdEnabled = config.services.nsd.enable;
  nsdPort = config.services.nsd.port;
in
  with lib;
    mkIf cfg.virtualization.virshle.enable {
      ## DhcpV6
      environment.systemPackages = with pkgs; [
        # dnsmasq
        kea
      ];

      services.kea = {
        ctrl-agent = {
          settings = {
            http-port = 5547;
            control-sockets = {
              dhcp4 = {
                socket-type = "unix";
                socket-name = "/run/kea/dhcp4.sock";
              };
              dhcp6 = {
                socket-type = "unix";
                socket-name = "/run/kea/dhcp6.sock";
              };
              d2 = {
                socket-type = "unix";
                socket-name = "/run/kea/ddns.sock";
              };
            };
          };
        };
        dhcp6 = {
          settings = {
            #Json
            control-socket = {
              socket-type = "unix";
              socket-name = "/run/kea/dhcp6.sock";
            };
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
              lfc-interval = 1000;
            };
            rebind-timer = 1000;
            renew-timer = 600;
            preferred-lifetime = -1;
            valid-lifetime = -1;
            hooks-libraries = [
              {
                library = "${pkgs.kea}/lib/kea/hooks/libdhcp_lease_cmds.so";
              }
              # {
              #   library = "${pkgs.kea}/lib/kea/hooks/libdhcp_ddns_cmds.so";
              # }
            ];
            dhcp-ddns = {
              enable-updates = true;
              server-ip = "::1";
              server-port = 53001;
            };
            ddns-update-on-renew = true;
            ddns-qualifying-suffix = "vm";
          };
        };
        dhcp4 = {
          settings = {
            control-socket = {
              socket-type = "unix";
              socket-name = "/run/kea/dhcp4.sock";
            };
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
              lfc-interval = 1000;
            };
            rebind-timer = 1000;
            renew-timer = 600;
            valid-lifetime = -1;
            hooks-libraries = [
              {
                library = "${pkgs.kea}/lib/kea/hooks/libdhcp_lease_cmds.so";
              }
              # {
              #   library = "${pkgs.kea}/lib/kea/hooks/libdhcp_ddns_cmds.so";
              # }
            ];
            dhcp-ddns = {
              enable-updates = true;
              server-ip = "::1";
              server-port = 53001;
            };
            ddns-update-on-renew = true;
            ddns-qualifying-suffix = "vm";
          };
        };

        dhcp-ddns = {
          settings = {
            control-socket = {
              socket-type = "unix";
              socket-name = "/run/kea/ddns.sock";
            };

            dns-server-timeout = 500;
            port = 53001;
            ip-address = "::1";
            forward-ddns = {
              ddns-domains = [
                {
                  name = "vm.";
                  dns-servers = [
                    {
                      ip-address = "::1";
                      port =
                        if nsdEnabled
                        then nsdPort
                        else 53;
                    }
                  ];
                }
              ];
            };
          };
        };
      };
      ###############################
      # Sytemd unit rework

      systemd.tmpfiles.rules = [
        "Z '/var/lib/kea' 764 root users - -"
      ];
      systemd.services = with lib; let
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
          AmbientCapabilities = [
            "CAP_NET_BIND_SERVICE"
            "CAP_NET_RAW"
          ];
          CapabilityBoundingSet = [
            "CAP_NET_BIND_SERVICE"
            "CAP_NET_RAW"
          ];
        };
      in {
        kea-ctrl-agent.serviceConfig = serviceConfig;
        kea-dhcp-ddns-server.serviceConfig = serviceConfig;
        kea-dhcp6-server.serviceConfig = serviceConfig;
        kea-dhcp4-server.serviceConfig = serviceConfig;
      };
    }
