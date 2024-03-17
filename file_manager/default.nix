{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in {
  # Import home files
  home-merger = with lib;
    mkIf cfg.terminal.file_manager.yazi.enable {
      enable = true;
      users = cfg.users;
      modules = [
        ./home.nix
      ];
    };

  users.groups = {
    storage.members = cfg.users;
  };

  environment.systemPackages = with pkgs; [
    unrar
    du-dust
    lolcat

    # Mount android phones
    #usbutils
    adbfs-rootless
    jmtpfs
    #glib
    #fuse3
  ];

  ################################
  ## Disk automount
  services.udisks2.enable = true; #stable
  environment.etc."udisks2/mount_options.conf".text = ''
    [defaults]
    btrfs_defaults=compress=zstd
    ntfs_defaults=uid=$UID,gid=$GID,prealloc
  '';

  ################################
  ### Phones
  ## Automount Google devices
  services.devmon.enable = true;
  # programs.udevil.enable = true; #unstable
  # services.gvfs.enable = true;
  services.udev.packages = with pkgs; [
    android-udev-rules
  ];
  # services.udev.extraRules = ''
  #   ACTION=="add", ENV{ID_BUS}=="usb",
  #   SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0660",
  #   GROUP="plugdev", SYMLINK+="pixel%k",
  #   RUN{program}+="${pkgs.systemd}/bin/systemd-mount --no-block --automount=yes --collect $devnode /run/media"
  # '';
  # services.autofs = {
  #   enable = true; #stable
  #   autoMaster = ''
  #
  #   '';
  # };
}
