{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in {
  ## User specific
  home-merger = {
    enable = true;
    users = cfg.users;
    modules = [
      ./home.nix
    ];
  };

  environment.systemPackages = with pkgs; [
    # VPN configuration/management utilities
    wireguard-tools
    # openvpn
    # networkmanager-openvpn

    # Alternative networks
    # Nym nodes
    nym
    # I2P network
    i2pd
    # Tor
    torsocks
    tor-browser
  ];

  ## Invisible Internet Project background service
  systemd.services."i2pd" = {
    enable = true;
    after = ["network.target"];
    serviceConfig = {
      ExecStart = "${pkgs.i2pd}/bin/i2pd";
    };
    wantedBy = ["multi-user.target"];
  };

  ## Tor background service
  services.tor = {
    enable = true;
  };
}
