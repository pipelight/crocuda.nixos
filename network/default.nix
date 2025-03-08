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
      networking.nameservers = [
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

      ##########################
      ## DHCP
      networking.dhcpcd = {
        enable = true;
        extraConfig = "nohook resolv.conf";
      };

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
        tshark
        iftop
        speedtest-go

        # Host scanning
        dig
        nmap

        # Query content
        curl
        wget

        # VPN
        wireguard-tools
        mullvad-vpn
      ];
    }
