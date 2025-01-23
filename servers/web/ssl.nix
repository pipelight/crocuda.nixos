{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib; let
  cfg = config.crocuda;
  units =
    concatMapAttrs
    (
      name: domains: {
        "certbot_${name}_" = {
          description = "Certbot update ssl certificates for ${name}";
          serviceConfig = {
            Type = "oneshot";
            User = "root";
            ExecStart =
              ''
                ${pkgs.certbot}/bin/certbot certonly \
                --cert-name ${name} \
              ''
              + concatMapStrings (domain: "-d ${domain} ") domains
              + ''
                --standalone \
                -n
              '';

            StandardInput = "null";
            StandardOutput = "journal+console";
            StandardError = "journal";
          };
        };
      }
    )
    cfg.servers.web.letsencrypt.domains;
in
  mkIf cfg.servers.web.letsencrypt.enable {
    environment.systemPackages = with pkgs; [
      certbot
    ];

    systemd.timers."certbot" = {
      wantedBy = ["timers.target"];
      timerConfig = {
        OnBootSec = "5m";
        OnCalendar = "monthly";
        OnUnitActiveSec = "5m";
        Unit = "certbot.service";
      };
    };
    systemd.services = units;
  }
