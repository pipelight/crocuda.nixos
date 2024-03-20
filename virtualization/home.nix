{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  home.file = {
    ".config/libvirt/qemu.conf".source = dotfiles/qemu.conf;
  };
  }
