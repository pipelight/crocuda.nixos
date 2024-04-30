# Autostart Hyprland on login
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
  Hyprland
fi

# Autostart Hyprland on login
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty2 ]]; then
  gnome
fi
