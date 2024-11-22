################################
## Android
# This module enable compatibility for devices under GrapheneOs.
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # Adb sideload
    android-tools

    # Mount android phones
    adbfs-rootless
    jmtpfs
    glib

    # Work with usb devices
    usbutils
  ];

  ################################
  ### Phones
  ## Automount Google devices

  services.udev.packages = with pkgs; [
    android-udev-rules
  ];
}
