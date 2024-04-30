# Autostart Hyprland on login
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
  Hyprland
fi

# Autostart Hyprland on login
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty2 ]]; then
 dbus-run-session -- gnome-shell --display-server --wayland
fi
