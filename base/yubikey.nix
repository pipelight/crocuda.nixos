{
  config,
  pkgs,
  lib,
  ...
}: let
in {
  environment.systemPackages = with pkgs; [
    yubikey-manager
    usbutils
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

  systemd.services."kill_all_sessions" = {
    description = "Kill all sessions";
    serviceConfig = {
      ExecStart = ''
        ${pkgs.procps}/bin/ps aux | egrep '(tty|pts)' | xargs kill -KILL
      '';
      Type = "oneshot";
    };
    wantedBy = ["multi-user.target"];
  };
  services.udev.extraRules = ''
    ACTION=="remove",\
    ENV{ID_BUS}=="usb",\
    ENV{ID_MODEL_ID}=="0407",\
    ENV{ID_VENDOR_ID}=="1050",\
    ENV{ID_VENDOR}=="Yubico",\
    RUN+="${pkgs.systemd}/bin/systemctl start kill_all_sessions"
  '';
}
