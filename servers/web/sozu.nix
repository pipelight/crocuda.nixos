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
  sozu = pkgs-unstable.sozu;
in
  with lib;
    mkIf cfg.servers.web.sozu.enable {
      environment.systemPackages = [
        # Tcp proxy written in Rust
        sozu
      ];

      # Systemd unit template adapted from sozu doc/recipe.md
      systemd.services."sozu" = {
        description = "Sozu - A HTTP reverse proxy, configurable at runtime, fast and safe, built in Rust.";
        documentation = ["https://docs.rs/sozu/"];
        after = ["network-online.target"];
        wants = ["network-online.target"];
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          ExecStart = "${sozu}/bin/sozu start --config /etc/sozu/config.toml";
          ExecReload = "${sozu}/bin/sozu --config /etc/sozu/config.toml reload";
          Restart = "on-failure";
          # User = "sozu";
          # Group = "users";
          AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        };
      };
      systemd.tmpfiles.rules = [
        "d /etc/sozu 754 root users - -"
        "f /etc/sozu/state.json 754 root users - -"
      ];
      # environment.etc = {
      #   "sozu/config.toml".source = ./dotfiles/sozu/config.toml;
      # };
    }
