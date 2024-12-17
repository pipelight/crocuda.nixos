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
  mount_cryptstorage = pkgs.writeShellScriptBin "mount_cryptstorage" ''
    fn() {
      sudo mkdir -p /run/media/HDD
      sudo ${pkgs.systemd}/bin/systemd-cryptsetup attach cryptstorage /dev/disk/by-label/CRYPTSTORAGE
      sudo ${pkgs.util-linux}/bin/mount /dev/mapper/cryptstorage /run/media/HDD
    }
    fn
  '';
  umount_cryptstorage = pkgs.writeShellScriptBin "umount_cryptstorage" ''
    fn() {
      sudo ${pkgs.util-linux}/bin/umount /run/media/HDD
      sudo ${pkgs.systemd}/bin/systemd-cryptsetup detach cryptstorage
    }
    fn
  '';
in
  with lib;
    mkIf cfg.office.yubikey.enable {
      boot.initrd.luks.yubikeySupport = true;

      services.udev.extraRules = ''
        ACTION=="remove",\
        ENV{SUBSYSTEM}=="usb",\
        ENV{PRODUCT}=="1050/407/543",\
        RUN+="${pkgs.systemd}/bin/systemctl start kill_all_sessions",\
        RUN+="${umount_cryptstorage}/bin/umount_cryptstorage"
      '';
      environment.systemPackages = with pkgs; [
        # Yubikey
        yubikey-manager
        yubikey-personalization
        yubico-pam

        usbutils
        procps
        kill_all_sessions

        mount_cryptstorage
        umount_cryptstorage
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
