{
  config,
  pkgs,
  lib,
  ...
}: {
  services.udev.packages = [pkgs.yubikey-personalization];

  environment.systemPackages = with pkgs; [
  yubikey-manager
    ];
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #};
  
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };
}
