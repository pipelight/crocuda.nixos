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
      users.groups = {
        storage.members = cfg.users;
      };

      # Allow unfree software
      allow-unfree = [
        "unrar"
      ];

      environment.systemPackages = with pkgs; [
        # Archive
        unzip

        #File management
        rsync

        # For bsdtar
        libarchive

        unrar
        du-dust

        udevil
      ];

      # programs.udevil.enable = true; #unstable do not use yet
      services.devmon.enable = true; #not customisable
      services.gvfs.enable = true;
      services.udisks2.enable = true;

      ################################
      ## Disk automount
      # ntfs_defaults=uid=$UID,gid=$GID,prealloc
      environment.etc."udisks2/mount_options.conf".text = ''
        [defaults]
        btrfs_defaults=compress=zstd
        ntfs_defaults=uid=$UID,gid=$GID
      '';
      # Ignore btrfs RAID disks
      services.udev.extraRules = ''
        ENV{ID_FS_LABEL}=="RAID",\
        ENV{ID_FS_TYPE}=="btrfs",\
        ENV{UDISKS_IGNORE}="1"
      '';
    }
