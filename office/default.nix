{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in {
  imports = [
    ./printer.nix
    ./yubikey.nix
    ./stream/default.nix
    ./gaming/default.nix
    ./draw/default.nix
    ./chat/default.nix
  ];

  home-merger = {
    enable = true;
    users = cfg.users;
    modules = [
      ./home.nix
    ];
  };
}
