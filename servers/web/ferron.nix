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
      environment.systemPackages = [
        # Webserver written in Rust
        ferron
      ];
      environment.etc.
        "ferron/config.kdl".text =
        inputs.nix-std.lib.serde.toTOML cfg.servers.web.sozu.config;

      # Systemd unit template adapted from sozu doc/recipe.md
      systemd.services."ferron" = {
        description = "Ferron - A fast, memory-safe web server written in Rust.";
        documentation = ["https://docs.rs/sozu/"];
        after = ["network-online.target"];
        wants = ["network-online.target"];
        wantedBy = ["multi-user.target"];
      };
    }
