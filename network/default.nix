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
      users.groups = let
        users = cfg.users;
      in {
        networkmanager.members = users;
      };

      # Prevent from enabling systemd network backend.
      networking.useNetworkd = lib.mkForce false;
      systemd.network.enable = lib.mkForce false;
      boot.initrd.systemd.network.enable = lib.mkForce false;

      ##########################
      ## Dns
      # Prevent from enabling systemd name resolution.
      services.resolved.enable = lib.mkForce false;

      # Set privacy respecting DNS
      networking.nameservers = lib.mkDefault [
        #Mullvad
        "194.242.2.4"
        "2a07:e340::4"
        #Quad9
        "9.9.9.9"
        "2620:fe::fe"
        "2620:fe::9"
      ];

      ##########################
      ## Firewall

      # Low level packet filtering
      # Replace legacy iptables with nftables
      networking.nftables.enable = true;

      networking.firewall = {
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

      environment.systemPackages = with pkgs; [
        # Network configuration
        nftables
        dhcpcd

        # Trafic inspection
        whois
        # tshark
        iftop
        speedtest-go
        traceroute

        # Host scanning
        dig
        bind

        nmap

        # Query content
        curl

        # VPN
        # wireguard-tools
        # mullvad-vpn
      ];
    }
