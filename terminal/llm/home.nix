{
  cfg,
  pkgs,
  lib,
  ...
}:
with lib;
  mkIf cfg.terminal.llm.ollama.enable {
    home.file = {
      ".config/mods/mods.yml".source = dotfiles/mods/mods.yml;
    };
    home.packages = with pkgs; [
      # Ai cli from charmbracelet/ charm.sh
      mods
      glow
    ];
  }
