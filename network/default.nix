{
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

      ##########################
      ## Tcp/ip

      users.groups.networkmanager.members = cfg.users;

      services.resolved.enable = lib.mkForce false;
      networking = {
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
            FastConnectable = "true";
            UserspaceHID = "true";
            Experimental = "true";
            KernelExperimental = "true";
          };
          Policy = {
            AutoEnable = "true";
          };
        };
      };
      # systemd.tmpfiles.rules = [
      #   "d /var/lib/bluetooth 700 root root - -"
      # ];
      # services.blueman = mkIf cfg.network.bluetooth.enable {
      #   enable = true;
      # };

      ##########################
      ## Ssh
      programs.ssh.startAgent = true;

      environment.systemPackages = with pkgs; [
        # Networking
        dhcpcd
        speedtest-go

        # Pentest
        whois
        tshark
        iftop
        dig
        nmap

        # VPN
        wireguard-tools
        mullvad-vpn
      ];
    }
