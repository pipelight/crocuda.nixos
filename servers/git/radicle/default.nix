{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
  # A dedicated unpriviledged user for public node
  username = "radicle";
in
  with lib;
    mkIf cfg.wm.hyprland.enable {
      users.users."${username}" = {
        isNormalUser = true;
      };

      nixpkgs.overlays = [rust-overlay.overlays.default];

      environment.systemPackages = let
        system = pkgs.system;
        rad = inputs.radicle.packages.${system};
        rad_web = inputs.radicle-interface.packages.${system};
      in
        with pkgs; [
          # Decentralized code collaboration plateform
          # radicle-cli
          # inputs.radicle.packages.${system}.default
          rad.default
          rad.radicle-httpd
          rust-bin.stable.latest.default
          (rad_web.default.override
            {
              doCheck = false;
            })

          # inputs.radicle-tui.packages.${system}.default
        ];

      # For a local dummy node either set a password and provide it to the
      # radicle systemd unit via variable a manualy created file at /etc/radicle.env
      # with the following
      # RAD_PASSPHRASE="my_password"

      environment.etc = {
        "radicle.conf".source = dotfiles/radicle.conf;
      };

      systemd.services."radicle-public-node" = {
        enable = true;
        description = "Radicle node daemon";
        documentation = ["https://radicle.xyz/guides/user"];
        requires = ["network-online.target"];
        serviceConfig = with pkgs; let
          system = pkgs.system;
          rad = inputs.radicle.packages.${system};
          package = rad.default;
        in {
          ExecStart = "${package}/bin/radicle-node --listen 0.0.0.0:8776 --force";
          User = "${username}";
          Group = "users";
          Type = "simple";
          Restart = "always";
          RestartSec = 3;
          WorkingDirectory = "/home/${username}";
          EnvironmentFile = "/etc/radicle.env";
        };
        wantedBy = ["multi-user.target"];
      };

      systemd.services."radicle-public-http" = {
        enable = true;
        description = "Radicle http daemon";
        documentation = ["https://radicle.xyz/guides/user"];
        requires = ["network-online.target"];
        serviceConfig = with pkgs; let
          system = pkgs.system;
          rad = inputs.radicle.packages.${system};
          package = rad.radicle-httpd;
        in {
          ExecStart = "${package}/bin/radicle-httpd --listen 127.0.0.1:8786 --force";
          User = "${username}";
          Group = "users";
          Type = "simple";
          Restart = "always";
          RestartSec = 3;
          WorkingDirectory = "/home/${username}";
          EnvironmentFile = "/etc/radicle.env";
        };
        wantedBy = ["multi-user.target"];
      };
    }
