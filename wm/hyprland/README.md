The are onto something with
[window rules](https://wiki.hyprland.org/Configuring/Window-Rules/).

- You may mix
  [window rules](https://wiki.hyprland.org/Configuring/Window-Rules/) to define
  window size and state depending on **class** and **onworkspace (how many
  windows are on the workspace)**.

- Swhkd, because its life. (Looking forward to dive in this piece of software)

- The missing part is some kind of watcher like what is possible with bspwm but
  with hyperland.

## with BSPWM;

suscribe to desktop events

```bash
bspc subscribe all
```

and read the buffer in a loop.

```bash
bspc subscribe all | while read -r _ ; do
    my_custom_script_in_wathever_language
done
```

(There might be some better alternatives than bash to read buffers although 💀)

