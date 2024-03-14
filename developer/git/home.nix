{
  config,
  pkgs,
  lib,
  inputs,
  # cfg,
  ...
}: {
  programs = {
    # Versionning
    git = {
      enable = true;
      userName = "areskill";
      userEmail = "areskul@areskul.com";
    };
  };
}
