{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  allow-unfree = [
    # Allow bottom tier apps
    "discord"
  ];

  imports = [
    ./firefox
  ];

  # Import home files
  home-merger = {
    enable = true;
    extraSpecialArgs = {inherit pkgs;};
    users = config.services.dapp.users;
    modules = [
      ./home.nix
    ];
  };

  environment.systemPackages = with pkgs; [
    ## Password managers
    keepassxc
    gnupg

    ## Search engine
    # A local search engine that gather other search engine results.
    # It anonimise searches by removing cookies and special params.
    # Furthermore no metadata collection (trackers, blueprint..)
    searxng
    # searxng dependencies
    redis

    # A terminal based chat application plugable with
    # ircd and darkirc
    weechat

    # Alternative networks
    # Nym nodes
    nym
    # I2P network
    i2pd
    # Tor
    torsocks
    tor-browser

    # Decentralized code collaboration plateform
    radicle-cli

    # Torrent
    qbittorrent

    # VPN configuration/management utilities
    wireguard-tools
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

  ## Searxng background service
  # and redis dependency
  systemd.services."searxng" = {
    enable = true;
    after = ["network.target"];
    serviceConfig = {
      ExecStart = "${pkgs.searxng}/bin/searxng-run";
    };
    wantedBy = ["multi-user.target"];
  };
  services.redis.servers."searxng-redis".enable = true;

  ## Tor background service
  services.tor = {
    enable = true;
  };

  environment.etc = {
    # Searxng configuration file
    "searxng/settings.yml".source = dotfiles/searx/settings.yml;
  };
}
