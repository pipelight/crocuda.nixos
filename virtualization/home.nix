{
  config,
  cfg,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
  mkIf cfg.virtualization.libvirt.enable {
    home.file = {
      ".config/libvirt/qemu.conf".source = dotfiles/qemu.conf;
    };
  }
