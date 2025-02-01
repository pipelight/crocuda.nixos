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
    mkIf cfg.terminal.shell.fish.enable {
      # programs.bash.interactiveShellInit = lib.readFile ./dotfiles/title.sh;
    }
