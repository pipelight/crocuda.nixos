{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in {
  # User specific
  home-merger = {
    enable = true;
    extraSpecialArgs = {inherit pkgs;};
    users = cfg.users;
    modules = [
      ./home.nix
    ];
  };

  ################################
  # Ssh
  services.openssh = with lib;
    mkIf cfg.servers.ssh.enable {
      enable = true;
      # require public key authentication for better security
      settings.PasswordAuthentication = false;
      settings.KbdInteractiveAuthentication = false;
      settings.PermitRootLogin = "yes";
    };

  environment.systemPackages = with pkgs; [
    # Decentralized code collaboration plateform
    radicle-cli
  ];
}
