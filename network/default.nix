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
      boot.kernelParams = ["IPv6PrivacyExtensions=1"];

      users.groups = let
        users = cfg.users;
      in {
        networkmanager.members = users;
        bluetooth.members = users;
      };

      services.resolved.enable = lib.mkForce false;
      networking = {
        ## Replace legacy iptables with nftables
        nftables = {
          stopRuleset = lib.readFile ./dotfiles/default.nft;
        };

        networkmanager = {
          enable = true;
          dns = "none";
          dhcp = "dhcpcd";
          connectionConfig = {
            ethernet = "cloned-mac-address =random";
            wifi = "cloned-mac-address=random";
            ipv6 = "ip6-privacy=2";
            ipv4 = "ignore-auto-dns=yes";
          };
          logLevel = "DEBUG";
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
        firewall = {
          enable = true;
          # libvirt DHCP compatibility
          checkReversePath = "loose";
          # allowedTCPPorts = [80 443];
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

        # VPN
        wireguard-tools
        mullvad-vpn
      ];
    }
