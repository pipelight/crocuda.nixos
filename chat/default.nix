{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in
  with lib;
    mkIf cfg.chat.enable {
  # Allow bottom tier apps
  allow-unfree = [
    "discord"
  ];
  # User specific
  home-merger = {
    enable = true;
    extraSpecialArgs = {inherit pkgs;};
    users = cfg.users;
    modules = [
      ./home.nix
    ];
  };
}
