{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.crocuda;
in
  with lib;
    mkIf cfg.logs.enable {
      services.rsyslogd = {
        enable = false;
      };
      services.logrotate = {
        enable = true;
      };
    }
