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
    mkIf cfg.network.tools.enable {
      users.groups = let
        users = cfg.users;
      in {
        networkmanager.members = users;
      };

      ##########################
      ## Dns
      # Enable dns local caching instead of resolvd.
      # services.unbound.enable = true;

      # Set privacy respecting DNS
      networking.nameservers = lib.mkDefault [
        # Mullvad
        "194.242.2.4"
        "2a07:e340::4"
        # Quad9
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
        grpcurl

        # VPN
        # wireguard-tools
        # mullvad-vpn
      ];
    }
