{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in {
  # Import home files
  home-merger = with lib; mkIf cfg.file_manager.yazi.enable {
    enable = true;
    users = cfg.users;
    modules = [
      ./home.nix
    ];
  };
}
