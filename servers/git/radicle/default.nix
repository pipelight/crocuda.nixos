{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
  username = "radicle";
in
  with lib;
    mkIf cfg.wm.hyprland.enable {
      users.users."${username}" = {
        isNormalUser = true;
      };

      environment.systemPackages = with pkgs; [
        # Decentralized code collaboration plateform
        # radicle-cli
        inputs.radicle.packages.${system}.default
        # inputs.radicle-tui.packages.${system}.default
      ];

      systemd.services."radicle-node" = {
        enable = true;
        description = "Radicle node daemon";
        documentation = ["https://radicle.xyz/guides/user"];
        requires = ["network-online.target"];
        serviceConfig = {
          ExecStart = "${pkgs.charm}/bin/rad node start";
          User = "${username}";
          Group = "users";
          Type = "simple";
          Restart = "always";
          RestartSec = 1;
          WorkingDirectory = "/home/${username}";
          # EnvironmentFile = ["/etc/charm.conf"];
        };
        wantedBy = ["multi-user.target"];
      };
    }
