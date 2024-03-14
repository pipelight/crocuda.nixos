# crocuda.nixos

...is a set of **nixos modules** which provide trivial configuration for
**paranoids** and **hypocondriacs**.

## Motivations

This project aim is to provide a well-documented NixOs base config with:

- **security and privacy**.
- **keyboard first** apps (qwerty, colemak-dh).

It is devided in **modules** that can be cherry picked or copy/pasted and
modified at your will.

## How are stuffs so tidy ?

Makes heavy usage of [home-merger](https://github.com/pipelight/nixos-utils) to
keep config files in separate dotfiles in their original formats, and keep a
consistent file tree.

## Installation and Usage


Internet;

- dns, self hosted dns with dns over https.
- search, searxng search engine configuration.

Developer;

- developer, which you may not want to use because it is very very opinionated.

#### Normy stuffs

Simple tools for everyday usage.

Web browsers:

- firefox (arkenfox and some more security params + tridactil)
- qutebrowser

Mail client:

- thunderbird

Password manager:

- KeepassXC (custom layout)

#### Developer stuffs

A developer toolkit for rust and web (non-exhaustiv).

IDE: NvChad(github theme) with multiple lsp(+linters +formatters). LSP: - Rust -
Deno - Bun - Typescript - Vue3(Vite, Vitepress... and the whole vue ecosystem) -
Pug - Tailwindcss - Nix - Lua

Shells: fish (github theme) default to bash

### Servers

Ssh Git Nginx-unit

#### VM (virtual machines)

mail

TODO: dns conf

Local test.com and example.com point to localhost (/etc/hosts).

### WM (window managers)

No Display manager. Log from the tty.

XORG -> Bspwm / Sxhkd (Sound/Backlight + Touchpad fixes)

```sh
startx bspwm
```

Terminal emulators:

- Raw xterm for failsafe
- Custom fancy kitty
