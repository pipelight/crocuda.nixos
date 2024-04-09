{
  config,
  pkgs,
  lib,
  ...
}: let
  kill_all_sessions = pkgs.writeShellScriptBin "kill_all_sessions.sh" ''
    ps aux | egrep '(tty|pts)' | awk '{print $2}' | xargs kill -KILL

  '';
in {
  services.udev.packages = [pkgs.yubikey-personalization];

  environment.systemPackages = with pkgs; [
    yubikey-manager
    kill_all_sessions
  ];
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #};

  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };
  services.udev.extraRules = ''
    ACTION=="remove",\
    ENV{ID_BUS}=="usb",\
    ENV{ID_MODEL_ID}=="0407",\
    ENV{ID_VENDOR_ID}=="1050",\
    ENV{ID_VENDOR}=="Yubico",\
    RUN+="kill_all_sessions.sh"
  '';
}
