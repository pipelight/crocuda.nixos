{
  config,
  pkgs,
  lib,
  inputs,
  system,
  ...
}: let
  cfg = config.crocuda;
in
  with lib;
    mkIf cfg.finance.monero.enable {
      boot.kernelParams = ["nr_hugepages=102400"];

      allow-unfree = [
        # "exodus"
      ];

      environment.systemPackages = with pkgs; [
        # Wallet
        # exodus

        # Mining
        xmrig
        p2pool
        monero-cli
        monero-gui
      ];

      users.users.monero = {
        isNormalUser = true;
        home = "/mnt/HDD/monero";
      };

      environment.etc = {
        # monero node conf
        "monero/monerod.conf".source = dotfiles/monero/monerod.conf;
        "monero/monerod.testnet.conf".source = dotfiles/monero/monerod.testnet.conf;
      };

      # Run monero node
      systemd.services."monerod" = {
        enable = false;
        after = ["network.target"];
        serviceConfig = {
          ExecStart = "${pkgs.monero-cli}/bin/monerod --config-file ~/monero/monero.conf";
          User = "monero";
          Group = "users";
          Type = "simple";
          # WorkingDirectory = "~";
          StateDirectory = "monero";
          LogsDirectory = "monero";
        };
        wantedBy = ["multi-user.target"];
      };

      systemd.services."monerod-testnet" = {
        enable = false;
        after = ["network.target"];
        serviceConfig = {
          ExecStart = "${pkgs.monero-cli}/bin/monerod --config-file ~/monero/monero.testnet.conf";
          User = "monero";
          Group = "users";
          Type = "simple";
          # WorkingDirectory = "~";
          StateDirectory = "monero";
          LogsDirectory = "monero";
        };
        wantedBy = ["multi-user.target"];
      };

      # Mine monero (validation node)
      services.xmrig = {
        enable = false;
        settings = {
          autosave = true;
          cpu = true;
          opencl = false;
          cuda = false;
          pools = [
            {
              url = "pool.supportxmr.com:443";
              user = "your-wallet";
              keepalive = true;
              tls = true;
            }
          ];
        };
      };
    }
