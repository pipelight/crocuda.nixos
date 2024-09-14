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
    mkIf cfg.finance.wownero.enable {
      boot.kernelParams = ["nr_hugepages=102400"];

      environment.systemPackages = with pkgs; [
        wownero
        # Mining
      ];

      systemd.tmpfiles.rules = [
        "d /mnt/HDD/wownero 755 wownero wownero - -"
      ];
      users.users.wownero = {
        home = "/mnt/HDD/wownero";
        isNormalUser = true;
      };

      environment.etc = {
        "wownero/wownerod.conf".source = dotfiles/wownero/wownerod.conf;
      };

      # Run wownero node
      systemd.services."wownerod" = {
        enable = true;
        after = ["network.target"];
        serviceConfig = {
          ExecStart = ''
            ${pkgs.wownero}/bin/wownerod \
              --config-file /etc/wownero/wownerod.conf \
              --non-interactive
          '';
          User = "wownero";
          Group = "users";
          Type = "simple";
          # WorkingDirectory = "~";
          StateDirectory = "wownero";
          LogsDirectory = "wownero";
        };
        wantedBy = ["multi-user.target"];
      };
    }
