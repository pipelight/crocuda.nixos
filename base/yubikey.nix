{
  config,
  pkgs,
  lib,
  ...
}: let
  kill_all_sessions = pkgs.writeShellScriptBin "kill_all_sessions" ''
    fn() {
      ${pkgs.procps}/bin/ps aux | egrep '(tty|pts)' | xargs kill -KILL
    }
    fn
  '';
in {
  environment.systemPackages = with pkgs; [
    yubikey-manager
    usbutils
    procps
    kill_all_sessions
  ];

  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };

  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #};

  services.pcscd.enable = true;

  services.udev.packages = with pkgs; [
    yubikey-personalization
    procps
    gnugrep
  ];

  systemd.services."kill_all_sessions" = {
    enable = true;
    description = "Kill all running sessions";
    serviceConfig = {
      ExecStart = "${kill_all_sessions}/bin/kill_all_sessions";
    };
  };

  services.udev.extraRules = ''
    ACTION=="remove",\
    ENV{SUBSYSTEM}=="usb",\
    ENV{PRODUCT}=="PRODUCT=1050/407/543",\
    RUN+="${pkgs.systemd}/bin/systemctl start kill_all_sessions"
  '';
}
