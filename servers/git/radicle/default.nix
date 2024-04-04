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

      # For a local dummy node either set a password and provide it to the
      # radicle systemd unit via variable a manualy created file at /etc/radicle.conf
      # with the following
      # RAD_PASSPHRASE="my_password"

      # environment.etc = {
      #   "radicle.conf".source = dotfiles/radicle.conf;
      # };

      systemd.services."radicle-node" = {
        enable = true;
        description = "Radicle node daemon";
        documentation = ["https://radicle.xyz/guides/user"];
        requires = ["network-online.target"];
        serviceConfig = with pkgs; let
          package = inputs.radicle.packages.${system}.default;
        in {
          ExecStart = "${package}/bin/rad node start --foreground";
          User = "${username}";
          Group = "users";
          Type = "simple";
          Restart = "always";
          RestartSec = 1;
          WorkingDirectory = "/home/${username}";
          EnvironmentFile = "/etc/radicle.conf";
        };
        wantedBy = ["multi-user.target"];
      };
    }
