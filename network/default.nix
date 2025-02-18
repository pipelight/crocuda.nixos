{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.crocuda;
in
  with lib;
    mkIf cfg.network.privacy.enable {
      boot = {
        kernelParams = ["IPv6PrivacyExtensions=1"];
        kernel.sysctl = {
          "net.ipv6.conf.all.use_tempaddr" = 1;
        };
      };

      services.dbus.implementation = "broker";

      users.groups = let
        users = cfg.users;
      in {
        networkmanager.members = users;
        bluetooth.members = users;
      };

      services.resolved.enable = lib.mkForce false;
      networking = {
        ## Replace legacy iptables with nftables

        networkmanager = {
          enable = true;
          dns = "none";
          dhcp = "internal";
          connectionConfig = {
            # "ethernet.cloned-mac-address" = mkDefault "random";
            # "ipv4.ignore-auto-dns" = mkDefault "yes";
            "wifi.cloned-mac-address" = mkDefault "random";
            "ipv6.ip6-privacy" = mkDefault "2";
          };
          logLevel = "INFO";
        };
        dhcpcd = {
          enable = true;
          extraConfig = "nohook resolv.conf";
        };
        nameservers = [
          #Quad9
          "9.9.9.9"
          "2620:fe::fe"
          #Mullvad
          # "100.64.0.63"
          "194.242.2.4"
          "2a07:e340::4"
          # local
          # "127.0.0.1"
          # "::1"
        ];
        nftables.enable = true;
        firewall = {
          enable = true;
          # libvirt DHCP compatibility
          checkReversePath = "loose";
          allowedTCPPorts = [
            # prod
            # 80 443
            # test
            # 3000
            # 5173
          ];
        };
      };

      ##########################
      ## Bluetooth

      hardware.bluetooth = mkIf cfg.network.bluetooth.enable {
        enable = true;
        powerOnBoot = true;
        settings = {
          General = {
            Enable = "Source,Sink,Media,Socket";
            ControllerMode = "bredr";
            # ControllerMode = "dual";
            FastConnectable = true;
            Experimental = true;
            KernelExperimental = false;
          };
          Policy = {
            AutoEnable = true;
          };
        };
        input = {
          General = {
            ClassicBondedOnly = false;
            UserspaceHID = true;
          };
        };
        network = {
          General = {
            DisableSecuriy = true;
          };
        };
      };
      services.blueman = mkIf cfg.network.bluetooth.enable {
        enable = true;
      };

      # systemd.tmpfiles.rules = [
      #   "d /var/lib/bluetooth 700 root root - -"
      # ];

      ##########################
      ## Ssh
      programs.ssh.startAgent = true;

      environment.systemPackages = with pkgs; [
        # Networking
        nftables
        dhcpcd
        speedtest-go

        whois
        tshark
        iftop
        dig
        nmap

        # Query
        curl
        wget

        # dhcp config

        # VPN
        wireguard-tools
        mullvad-vpn
      ];
    }
