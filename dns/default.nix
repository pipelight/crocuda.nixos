{
  config,
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    unbound-with-systemd
    nsd
    dig
  ];
  environment.etc = {
  };
  # Run as dns user
  users.users.dns = {
    isNormalUser = true;
    home = "/home/dns";
  };
}
