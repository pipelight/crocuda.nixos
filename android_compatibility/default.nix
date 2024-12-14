################################
## Android
# This module enable compatibility for devices under GrapheneOs.
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
    mkIf cfg.office.android.enable
    {
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

      # automount android devices
      services.udev.packages = with pkgs; [
        android-udev-rules
      ];
    }
