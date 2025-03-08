{
  config,
  cfg,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
  mkIf cfg.terminal.shell.utils.enable {
    home.packages = with pkgs; [
      ## Password managers
      keepassxc
      gnupg
      cryptsetup
      # Nixos easy cli
      # inputs.nixos-cli.packages.${system}.default
    ];

    home.file = {
      # ".config/keepassxc/keepassxc.ini".source = dotfiles/keepassxc/keepassxc.ini;
    };
  }
