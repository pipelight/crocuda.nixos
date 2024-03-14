{
  config,
  pkgs,
  lib,
  utils,
  inputs,
  ...
}: let
  cfg = config.services.wm;
in {
  # Import home file
  home-merger = {
    enable = true;
    users = cfg.users;
    modules = [
      ./home.nix
    ];
  };
  environment.systemPackages = with pkgs; [
    # Window manager
    gnome.gnome-session
    gnome.gnome-shell
    wayland
    bspwm
    sxhkd
    # dunst
    # xsel
    redshift
    # Screenshots
    scrot
    # Fancy bspwm
    # eww
    xdotool
    feh
    rofi
    picom-next
  ];

  # systemd.user.tmpfiles.rules = [
  #   "L %h/.local/share/bspwm/"
  # ];

  # systemd.user.services."bspwm_session_save" = {
  #   enable = true;
  #   description = "Save bspwm layout";
  #   before = ["halt.target" "shutdown.target" "reboot.target"];
  #   wantedBy = ["halt.target" "shutdown.target" "reboot.target"];
  #   serviceConfig = {
  #     WorkingDirectory = "%h";
  #     User = "%u";
  #     Group = "users";
  #     Type = "oneshot";
  #     ExecStart = "${pkgs.bspwm}/bin/bspc wm -d > %h/.local/share/bspwm/state.json";
  #     RemainAfterExit = true;
  #     StandardError = "journal";
  #     StandardOutput = "journal";
  #   };
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # Disable Display Manager (lightdm)
  services.xserver.displayManager.startx.enable = true;

  # services.xserver.windowManager.bspwm.enable = true;

  # Touchpad and mouse
  services.xserver.libinput.touchpad.naturalScrolling = true;

  # Cursor theming
  environment.variables.XCURSOR_SIZE = "24";
}
