{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.crocuda;
  kill_all_sessions = pkgs.writeShellScriptBin "kill_all_sessions" ''
    fn() {
      ${pkgs.procps}/bin/ps aux | egrep '(tty|pts)' | xargs kill -KILL
    }
    fn
  '';
in
  with lib;
    mkIf cfg.yubikey.enable {
      environment.systemPackages = with pkgs; [
        # Yubikey
        yubikey-manager
        yubikey-personalization
        yubico-pam

        usbutils
        procps
        kill_all_sessions
      ];

      # security.pam.services = {
      #   login.u2fAuth = true;
      #   sudo.u2fAuth = true;
      # };

      # programs.gnupg.agent = {
      #   enable = true;
      #   enableSSHSupport = true;
      #};

      services.pcscd.enable = true;

      services.udev.packages = with pkgs; [
        yubikey-personalization
        procps
        gnugrep
      ];

      systemd.services."kill_all_sessions" = {
        enable = true;
        description = "Kill all running sessions";
        serviceConfig = {
          ExecStart = "${kill_all_sessions}/bin/kill_all_sessions";
        };
      };
      # systemd.services."lock_session" = {
      #   enable = true;
      #   description = "Kill all running sessions";
      #   serviceConfig = {
      #     ExecStart = "${pkgs.hyprlock}/bin/hyprlock";
      #   };
      # };
    }
