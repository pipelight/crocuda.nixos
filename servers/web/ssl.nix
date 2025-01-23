{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib; let
  cfg = config.crocuda;
  units = mapAttrs (
    name: domains: {
      "ssl-autorenew-${name}" = {
        script = ''
          set -eu
          ${pkgs.certbot}/bin/certbot certonly \
          --cert-name pipelight.dev \
          ${map (domain: "-d ${domain} \\") domains}
        '';
        serviceConfig = {
          Type = "oneshot";
          User = "root";
        };
      };
    }
  ) [];
in
  mkIf cfg.servers.web.letsencrypt.enable {
    environment.systemPackages = with pkgs; [
      certbot
    ];

    systemd.timers."ssl-autorenew" = {
      wantedBy = ["timers.target"];
      timerConfig = {
        OnBootSec = "5m";
        OnCalendar = "monthly";
        OnUnitActiveSec = "5m";
        Unit = "ssl-autorenew.service";
      };
    };
    systemd.services = units;
  }
