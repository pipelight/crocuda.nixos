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
      obs-pipewire-audio-capture
      # obs-backgroundremoval
      # input-overlay
    ];
  };
}
