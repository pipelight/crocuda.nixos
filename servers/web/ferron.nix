{
  config,
  pkgs,
  pkgs-unstable,
  pkgs-deprecated,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in
  with lib;
    mkIf cfg.servers.web.ferron.enable {
      environment.systemPackages = with pkgs; [
        # Webserver written in Rust
        ferron
      ];

      crocuda.servers.web.sozu.config = mkBefore (builtins.readFile ./dotfiles/ferron/default.kdl);

      systemd.services."ferron" = {
        description = "Ferron - A fast, memory-safe web server written in Rust.";
        documentation = ["https://ferron.sh/docs"];
        after = ["network-online.target"];
        wants = ["network-online.target"];
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          ExecStart = "${ferron}/bin/ferron --config /etc/ferron/config.kdl";
          Restart = "on-failure";
          AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        };
      };
      environment.etc.
        "ferron/config.kdl".text = cfg.servers.web.ferron.config;
    }
