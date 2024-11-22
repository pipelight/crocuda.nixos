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

        unrar
        du-dust
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
    }
