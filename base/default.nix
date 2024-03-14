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

  environment.systemPackages = with pkgs; [
    git
  ];
}
