## This is a random system configuration.
## You should use your custom configuration file instead.
{
  pkgs,
  lib,
  ...
}: {
  # Use the systemd-boot EFI boot loader.
  # boot.kernelPackages = pkgs.linuxPackages;
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot = {
        enable = true;
        graceful = true;
      };
      efi.canTouchEfiVariables = true;
    };
  };
  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "25.05";
  system.autoUpgrade.channel = "https://nixos.org/channels/nixos-25.05";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
