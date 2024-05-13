{
  config,
  cfg,
  pkgs,
  lib,
  inputs,
  ...
}: {
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture

      input-overlay
      
    ];
  };
}
