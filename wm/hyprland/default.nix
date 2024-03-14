{
  config,
  pkgs,
  lib,
  utils,
  inputs,
  ...
}: let
cfg = config.crocuda;
  convert_to_grayscale = pkgs.writeShellScriptBin "convert_to_grayscale" ''
    convert $1 -colorspace gray $1.gray.jpeg
  '';
in {
  # Import home file
  home-merger = {
    enable = true;
    extraSpecialArgs = {inherit pkgs inputs;};
    users = cfg.users;
    modules = [
      ./home.nix
    ];
  };
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  environment.systemPackages = with pkgs; [
    wl-clipboard
    # Screen light
    redshift
    feh
    convert_to_grayscale

    #Keyboard
    via
  ];

  services.udev.packages = with pkgs; [
    via
  ];
}
