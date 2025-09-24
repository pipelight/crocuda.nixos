{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.crocuda;
in
  with lib;
    mkIf cfg.servers.logs.enable {
      services.rsyslogd = {
        enable = true;
        defaultConfig = ''

        '';
      };
      services.logrotate = {
        enable = true;
      };
      environment.systemPackages = with pkgs; [
        logrotate
        rsyslog
      ];
    }
