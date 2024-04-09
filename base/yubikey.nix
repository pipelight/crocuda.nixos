{
  config,
  pkgs,
  lib,
  ...
}: let
  kill_all_sessions = pkgs.writeShellScriptBin "kill_all_sessions" ''
    ps aux | egrep '(tty|pts)' | awk '{print $2}' | xargs kill -KILL
  '';
in {
  environment.systemPackages = with pkgs; [
    yubikey-manager
    usbutils
  ];

  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };

  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #};

  services.udev.packages = with pkgs;[
    yubikey-personalization
    procps
    
  ];

  services.udev.extraRules = ''
    ACTION=="remove",\
      ENV{ID_BUS}=="usb",\
      ENV{ID_MODEL_ID}=="0407",\
      ENV{ID_VENDOR_ID}=="1050",\
      ENV{ID_VENDOR}=="Yubico",\
      RUN+="${kill_all_sessions}"
  '';
}
