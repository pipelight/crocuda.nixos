#!/usr/bin/env fish

# Autostart Hyprland on login
set current_tty $(tty)
set is_display $(set -q $DISPLAY)

if [ -n $DISPLAY ] && [ $current_tty = /dev/tty1 ];
  export XDG_CURRENT_DESKTOP=niri
  niri --session
end

if [ -n $DISPLAY ] && [ $current_tty = /dev/tty2 ];
  export XDG_CURRENT_DESKTOP=Hyprland
  Hyprland
end

if [ -n $DISPLAY ] && [ $current_tty = /dev/tty3 ];
  export XDG_CURRENT_DESKTOP=GNOME
  dbus-run-session -- gnome-shell --display-server --wayland
end

