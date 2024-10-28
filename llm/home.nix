{
  cfg,
  pkgs,
  lib,
  ...
}: {
  home.file = {
    ".config/mods/mods.yml".source = dotfiles/mods/mods.yml;
  };
  home.packages = with pkgs; [
    # Ai cli from charmbracelet/ charm.sh
    mods
    glow
  ];
  allow-unfree = [
    # AI
    "lib.*"
    "cuda.*"
  ];
}
