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
      users.groups = {
        networkmanager.members = config.crocuda.users;
      };

      ##########################
      ## Dns
      # Enable dns local caching instead of resolvd.
      # services.unbound.enable = true;

      ##########################
      ## Firewall
      # Replace legacy iptables with nftables
      networking.nftables.enable = true;
      networking.firewall = {
        enable = true;
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
