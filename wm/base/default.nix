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
    mkIf cfg.wm.hyprland.enable {
  # User specific
  home-merger = {
    enable = true;
    extraSpecialArgs = {inherit pkgs;};
    users = cfg.users;
    modules = [
      ./home.nix
    ];
  };

  ## Video /Sound
  # Disable old software
  sound.enable = false;
  hardware.pulseaudio.enable = false;
  # Enable new software
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.groups = {
    audio.members = cfg.users;
    video.members = cfg.users;
  };

  environment.systemPackages = with pkgs; [
    # pactl audio control cli
    pulseaudio
    pamixer

  ];
}
