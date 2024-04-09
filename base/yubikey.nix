{
  config,
  pkgs,
  lib,
  ...
}: let
  kill_all_sessions = pkgs.writeShellScriptBin "kill_all_sessions" ''
    ${pkgs.procps}/bin/ps aux | egrep '(tty|pts)' | awk '{print $2}' | xargs kill -KILL
    # ps aux | egrep '(tty|pts)' | awk '{print $2}' | xargs kill -KILL
  '';
in {
  environment.systemPackages = with pkgs; [
    yubikey-manager
    usbutils
    kill_all_sessions
    procps
  ];

  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };

  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #};

  services.udev.packages = with pkgs; [
    yubikey-personalization
    procps
    gnugrep
  ];

  services.udev.extraRules = ''
    ACTION=="remove",\
      ENV{ID_BUS}=="usb",\
      ENV{ID_MODEL_ID}=="0407",\
      ENV{ID_VENDOR_ID}=="1050",\
      ENV{ID_VENDOR}=="Yubico",\
      RUN+="${pkgs.procps}/bin/ps aux | egrep '(tty|pts)' | awk '{print $2}' | xargs kill -KILL"
  '';
}
