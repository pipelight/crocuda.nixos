{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in
  with lib;
    mkIf cfg.browser.i2p.enable {
      ## User specific
      home-merger = {
        enable = true;
        users = cfg.users;
        modules = [
          ./home.nix
        ];
      };

      environment.systemPackages = with pkgs; [
        # Alternative networks
        # Nym nodes
        nym
        # I2P network
        i2pd
        # Tor
        torsocks
        tor-browser
      ];

      environment.etc = {
        "i2pd/i2pd.conf".source = dotfiles/i2pd/i2pd.conf;
      };

      services.i2pd = {
        enable = true;
      };

      ## Tor background service
      services.tor = {
        enable = true;
      };
    }
