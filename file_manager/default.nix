{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in
  with lib;
    mkIf cfg.terminal.file_manager.enable {
      # Import home files
      home-merger = {
        enable = true;
        users = cfg.users;
        modules = [
          ./home.nix
        ];
      };

      users.groups = {
        storage.members = cfg.users;
      };

      # Allow unfree software
      allow-unfree = [
        "unrar"
      ];

      environment.systemPackages = with pkgs; [
        unrar
        du-dust

        # Mount android phones
        adbfs-rootless
        jmtpfs
        glib

        usbutils
      ];

      services.udisks2.enable = true; #stable
      # programs.udevil.enable = true; #unstable do not use yet
      services.devmon.enable = true;
      services.gvfs.enable = true;

      ################################
      ## Disk automount
      # ntfs_defaults=uid=$UID,gid=$GID,prealloc
      environment.etc."udisks2/mount_options.conf".text = ''
        [defaults]
        btrfs_defaults=compress=zstd
        ntfs_defaults=uid=$UID,gid=$GID
      '';

      ################################
      ### Phones
      ## Automount Google devices

      services.udev.packages = with pkgs; [
        android-udev-rules
      ];
    }
