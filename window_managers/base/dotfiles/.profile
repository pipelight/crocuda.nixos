# Autostart Hyprland on login
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
  export XDG_CURRENT_DESKTOP=Hyprland
  Hyprland
fi

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty2 ]]; then
  export XDG_CURRENT_DESKTOP=GNOME
  dbus-run-session -- gnome-shell --display-server --wayland
fi

