##########################
## OpenVSwitch
# It manages virtual network.
# Is used to create network bridges and endpoints.
# Do the heavilifting of "ip" and "nftables".
{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in
  with lib;
    mkIf cfg.virtualization.openvswitch.enable {
      boot.kernelModules = ["openvswitch"];

      environment.systemPackages = with pkgs; [
        pkgs-unstable.openvswitch
      ];

      systemd.tmpfiles.rules = [
        "f /var/run/openvswitch/db.sock 754 root users - -"
        "f /var/run/openvswitch/system-id.conf 754 root users - -"
      ];

      # Systemd units
      # adapted from openvswitch debian/*.services

      systemd.services = let
        db-file = "/var/run/openvswitch/conf.db";
      in {
        openvswitch = {
          enable = true;
          description = "Open vSwitch";

          #Unit
          before = ["network.target"];
          after = ["network-pre.target" "ovsdb-server.service" "ovs-vswitchd.service"];
          partOf = ["network.target"];
          requires = ["ovs-vswitchd.service" "ovsdb-server.service"];
          #Install
          wantedBy = ["multi-user.target"];
          # also = "ovs-record-hostname.service";

          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${pkgs.coreutils}/bin/true";
            ExecReload = "${pkgs-unstable.openvswitch}/share/openvswitch/scripts/ovs-systemd-reload";
            ExecStop = "${pkgs.coreutils}/bin/true";
            RemainAfterExit = "yes";

            StandardError = "journal";
            StandardOutput = "journal";
            StandardInput = "null";
          };
        };

        ovsdb-server = {
          enable = true;
          description = "Open vSwitch Database Unit";

          #Unit
          before = ["network.target" "networking.service"];
          after = ["systemd-journald.socket" "network-pre.target" "dpdk.service" "local-fs.target"];
          partOf = ["openvswitch-switch.service"];
          # defaultDebendencies = "no";

          serviceConfig = {
            LimitNOFILE = "1048576";
            Type = "forking";
            Restart = "on-failure";
            Environment = [
              "HOME=/var/run/openvswitch"
              "OVS_SYSCONFDIR=/var/run"
              "PATH=$PATH:${lib.makeBinPath [pkgs.gawk pkgs.coreutils pkgs.gnused pkgs.libuuid]}"
            ];
            EnvironmentFile = "-/etc/default/openvswitch-switch";

            #Ensure database exists
            ExecStartPre = ''
              -${pkgs-unstable.openvswitch-dpdk}/bin/ovsdb-tool \
                create /var/run/openvswitch/conf.db
            '';
            ExecStart = ''
              ${pkgs-unstable.openvswitch-dpdk}/share/openvswitch/scripts/ovs-ctl \
                --no-ovs-vswitchd \
                --no-monitor \
                --system-id=random \
                --no-record-hostname \
                --db-file=${db-file} \
                start $OVS_CTL_OPTS
            '';
            ExecStop = ''
              ${pkgs-unstable.openvswitch-dpdk}/share/openvswitch/scripts/ovs-ctl \
                --no-ovs-vswitchd stop
            '';
            ExecReload = ''
              ${pkgs-unstable.openvswitch-dpdk}/share/openvswitch/scripts/ovs-ctl \
                --no-ovs-vswitchd \
                --no-record-hostname \
                --no-monitor \
                --db-file=${db-file} \
                restart $OVS_CTL_OPTS
            '';
            RuntimeDirectory = "openvswitch";
            RuntimeDirectoryMode = 0755;
            RuntimeDirectoryPreserve = "yes";

            StandardError = "journal";
            StandardOutput = "journal";
            StandardInput = "null";
          };
        };

        ovs-vswitchd = {
          enable = true;
          description = "Open vSwitch Forwarding Unit";

          after = ["ovsdb-server.service" "network-pre.target" "systemd-udev-settle.service"];
          before = ["network.target" "networking.service"];
          requires = ["ovsdb-server.service"];
          # reloadPropagatedFrom = "ovsdb-server.service";
          # assertPathIsReadWrite = "/var/run/openvswitch/db.sock";
          partOf = ["openvswitch-switch.service"];
          # defaultDependencies = "no";

          serviceConfig = {
            LimitNOFILE = 1048576;
            Type = "forking";
            Restart = "on-failure";
            User = "root";
            Environment = [
              "HOME=/var/run/openvswitch"
              "OVS_SYSCONFDIR=/var/run"
              "PATH=$PATH:${lib.makeBinPath [pkgs.gawk pkgs.coreutils pkgs.gnused pkgs.libuuid]}"
            ];
            # EnvironmentFile = "-/etc/default/openvswitch-switch";
            ExecStart = ''
              ${pkgs-unstable.openvswitch}/share/openvswitch/scripts/ovs-ctl \
                --no-ovsdb-server \
                --no-monitor \
                --system-id=random \
                --no-record-hostname \
                start $OVS_CTL_OPTS
            '';
            ExecStop = ''
              ${pkgs-unstable.openvswitch}/share/openvswitch/scripts/ovs-ctl \
                --no-ovsdb-server \
                stop $OVS_CTL_OPTS
            '';
            ExecReload = ''
              ${pkgs-unstable.openvswitch}/share/openvswitch/scripts/ovs-ctl \
                --no-ovsdb-server \
                --no-monitor \
                --system-id=random \
                --no-record-hostname \
                restart $OVS_CTL_OPTS
            '';
            TimeoutSec = 300;

            StandardError = "journal";
            StandardOutput = "journal";
            StandardInput = "null";
          };
        };

        ovs-ipsec = {
          enable = false;
          description = "Open vSwitch IPsec daemon";

          requires = ["openvswitch-switch.service"];
          after = ["openvswitch-switch.service"];
          wantedBy = ["multi-user.target"];

          serviceConfig = {
            Type = "forking";
            PIDFile = "/run/openvswitch/ovs-monitor-ipsec.pid";
            Environment = [
              "HOME=/var/run/openvswitch"
              "OVS_SYSCONFDIR=/var/run"
            ];
            ExecStart = ''
              ${pkgs-unstable.openvswitch}/share/openvswitch/scripts/ovs-ctl \
                  --ike-daemon=strongswan \
                  start-ovs-ipsec
            '';
            ExecStop = ''
              ${pkgs-unstable.openvswitch}/share/openvswitch/scripts/ovs-ctl \
                stop-ovs-ipsec
            '';

            StandardError = "journal";
            StandardOutput = "journal";
            StandardInput = "null";
          };
        };

        ovs-record-hostname = {
          enable = true;
          description = "Open vSwitch Record Hostname";
          after = ["ovsdb-server.service" "ovs-vswitchd.service" "network-online.target"];
          requires = ["ovsdb-server.service" "ovs-vswitchd.service" "network-online.target"];
          # assertPathIsReadWrite = "/var/run/openvswitch/db.sock";

          requiredBy = ["openvswitch-switch.service"];
          serviceConfig = {
            Type = "oneshot";
            Environment = with pkgs; [
              "HOME=/var/run/openvswitch"
              "OVS_SYSCONFDIR=/var/run"
              "PATH=$PATH:${lib.makeBinPath [gawk coreutils gnused nettools]}"
            ];
            ExecStart = ''
              ${pkgs-unstable.openvswitch}/share/openvswitch/scripts/ovs-ctl \
                record-hostname-if-not-set
            '';
            ExecStop = "${pkgs.coreutils}/bin/true";
            ExecReload = ''
              ${pkgs-unstable.openvswitch}/share/openvswitch/scripts/ovs-ctl \
                record-hostname-if-not-set
            '';
            TimeoutSec = 300;
            RemainAfterExit = "yes";

            StandardError = "journal";
            StandardOutput = "journal";
            StandardInput = "null";
          };
        };
      };
    }
