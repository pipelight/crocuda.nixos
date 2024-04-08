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
  services.udev.extraRules = ''
     ACTION=="remove",\
     ENV{ID_BUS}=="usb",\
     ENV{ID_MODEL_ID}=="0407",\
     ENV{ID_VENDOR_ID}=="1050",\
     ENV{ID_VENDOR}=="Yubico",\
     RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
     RUN+="ps aux | egrep '(tty|pts)' | awk '{print $2}' | xargs kill -KILL"
  '';
}
