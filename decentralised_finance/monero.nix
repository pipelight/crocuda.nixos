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
      boot.kernelParams = ["nr_hugepages=1000"];

      environment.systemPackages = with pkgs; [
        # Mining
        xmrig
        p2pool
        monero-cli
        monero-gui
      ];

      systemd.tmpfiles.rules = [
        "d /persist/monero 755 monero users - -"
      ];
      users.users.monero = {
        home = "/persist/monero";
        isNormalUser = true;
      };

      environment.etc = {
        # monero node conf
        "monero/monerod.conf".source = dotfiles/monero/monerod.conf;
        "monero/monerod.testnet.conf".source = dotfiles/monero/monerod.testnet.conf;
      };

      # Run monero node
      systemd.services."monerod" = {
        enable = true;
        after = ["network.target"];
        serviceConfig = {
          ExecStart = ''
            ${pkgs.monero-cli}/bin/monerod \
              --config-file /etc/monero/monerod.conf \
              --non-interactive
          '';
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
        enable = true;
        after = ["network.target"];
        serviceConfig = {
          ExecStart = ''
            ${pkgs.monero-cli}/bin/monerod \
            --config-file /etc/monero/monerod.testnet.conf \
            --non-interactive
          '';
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
        enable = true;
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
