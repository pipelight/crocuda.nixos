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

Here is a module using crocuda every options

```nix
{
  config,
  pkgs,
  inputs,
  ...
}: {
  crocuda = {
    users = ["anon"];

    keyboard.layout = "colemak-dh";

    base.enable = true;

    # Graphical
    wm.hyprland.enable = true;

    # Terminal stuffs
    terminal = {
      shell = {
        fish.enable = true;
      };
      editor = {
        nvchad.enable = true;
        vim.enable = true;
      };
      file_manager = {
        yazi.enable = true;
      };
    };

    browser = {
      firefox.enable = true;
      searxng.enable = true;
      i2p.enable = true;
      tor.enable = true;
    };

    finance = {
      monero.enable = false;
      darkfi.enable = false;
    };
  };
}
```

#### Normy stuffs

Internet navigation:

- firefox security enhanced: with an hardened version of arkenfox
- secure dns: with bind9 dns over https
- search engine: searxng search engine configuration.

Simple tools for everyday usage.

Password manager:

- KeepassXC (custom security centric layout)

#### Developer stuffs

A developer toolkit for rust and web (non-exhaustiv).

IDE: NvChad(github theme) with multiple lsp(+linters +formatters). LSP: - Rust -
Deno - Bun - Typescript - Vue3(Vite, Vitepress... and the whole vue ecosystem) -
Pug - Tailwindcss - Nix - Lua

Shells: fish (github theme) default to bash



