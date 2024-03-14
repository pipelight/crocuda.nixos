# Set variables from prompt
window_manager=$2

# Switch case
case "$window_manager" in
  bspwm)
    exec bspwm;;
  gnome-x)
    exec gnome-session;;
  gnome-w)
    dbus-run-session -- gnome-shell --display-server --wayland ;;
esac
