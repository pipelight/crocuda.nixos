{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  utils,
  inputs,
  ...
}:
with lib; {
  # Set the module options
  options.crocuda = {
    users = mkOption {
      type = with types; listOf str;
      description = ''
        The name of the user whome to add this module for.
      '';
      default = ["anon"];
    };

    # Set the keyboard layout
    keyboard.layout = mkOption {
      type = with types; enum ["colemak-dh" "qwerty" "azerty"];
      description = ''
        The default hyprland keybindings
      '';
      default = "colemak-dh";
    };

    yubikey.enable = mkEnableOption ''
      Toggle the module
    '';

    logs.enable = mkEnableOption ''
      Toggle rsyslog and logrotate
    '';

    cicd.enable = mkEnableOption ''
      Enable lightweight cicd tools
    '';

    network = {
      privacy.enable = mkEnableOption ''
        Enable ipv6 privacy features, quad9 dns.
      '';
      bluetooth.enable = mkEnableOption ''
        Enable ipv6 privacy features, quad9 dns.
      '';
    };

    # Set editors with the specified keyboard layout
    terminal = {
      emulators.enable = mkEnableOption ''
        Toggle the module
      '';
      editors.enable = mkEnableOption ''
        Toggle the module
      '';
      # Set shell with the specified keyboard layout
      shell = {
        utils.enable = mkEnableOption ''
          add fast find command and utils
        '';
        fish.enable = mkEnableOption ''
          Toggle the module
        '';
      };
      file_manager.enable = mkEnableOption ''
        Toggle the module
      '';
      torrent.enable = mkEnableOption ''
        Toggle the module
      '';
    };

    llm = {
      ollama = {
        enable = mkEnableOption ''
          Toggle the ollama
        '';
      };
    };

    virtualization = {
      init = {
        enable = mkEnableOption ''
          Toggle pipelight as cloud init replacement
        '';
      };
      libvirt = {
        enable = mkEnableOption ''
          Toggle libvirt usage
        '';
      };
      docker = {
        enable = mkEnableOption ''
          Toggle docker usage
        '';
      };
    };
    chat = {
      enable = mkEnableOption ''
        Toggle libvirt usage
      '';
    };

    servers = {
      social = {
        mastodon.enable = mkEnableOption ''
          Enable mastodon with bird Ui.
        '';
      };
      dns = {
        enable = mkEnableOption ''
          Enable complete secured dns suite
          (unbound + nsd).
        '';
      };
      web = {
        pebble.enable = mkEnableOption ''
          Pebble acme validation test suite.
        '';
        jucenit.enable = mkEnableOption ''
          Jucenit web server.
        '';
      };
      ssh = {
        enable = mkEnableOption ''
          Toggle ssh daemon.
        '';
      };
      mail = {
        maddy = {
          enable = mkEnableOption ''
            Toggle the module
          '';
          domains = mkOption {
            type = with types; listOf str;
            description = ''
              List of domain to map to.
              The first domain of the list is used as the primary domain.
            '';
            default = ["example.com"];
          };
          accounts = mkOption {
            type = with types; listOf str;
            description = ''
              List of account to create
            '';
            default = ["anon@example.com"];
          };
        };
      };
      git = {
        radicle = {
          enable = mkEnableOption ''
            Run a git radicle instance module
          '';
        };
        soft = {
          enable = mkEnableOption ''
            Toggle the module
          '';
        };
        charm = {
          enable = mkEnableOption ''
            Toggle the module
          '';
        };
      };
    };

    browser = {
      firefox = {
        enable = mkEnableOption ''
          Toggle the module
        '';
      };
      searxng = {
        enable = mkEnableOption ''
          Toggle the module
        '';
      };
      i2p = {
        enable = mkEnableOption ''
          Run an i2pd node and create appropriate firefox profile.
        '';
      };
      tor = {
        enable = mkEnableOption ''
          Run  the module
        '';
      };
    };

    finance = {
      monero = {
        enable = mkEnableOption ''
          Run local monero node
        '';
        mining = {
          enable = mkEnableOption ''
            Toggle monero mining
          '';
        };
      };
      wownero = {
        enable = mkEnableOption ''
          Run local monero node
        '';
        mining = {
          enable = mkEnableOption ''
            Toggle monero mining
          '';
        };
      };
      darkfi = {
        enable = mkEnableOption ''
          Run local darkfi node
        '';
      };
    };

    # Window manager
    # Heavily customed hypr
    wm = {
      hyprland.enable = mkEnableOption ''
        Toggle the hyprland window manager
      '';
      gnome.enable = mkEnableOption ''
        Toggle gnome desktop environment
      '';
    };
    stream.enable = mkEnableOption ''
      Toggle streaming module
    '';
  };

  imports = [
    inputs.lix-module.nixosModules.default

    inputs.nixos-tidy.nixosModules.home-merger # replaces home-manager import
    inputs.nixos-tidy.nixosModules.allow-unfree

    inputs.impermanence.nixosModules.impermanence

    inputs.jucenit.nixosModules.jucenit

    # Add single top level import of NUR (Nixos User repository)
    # for nixosModules usage
    # and for inner hmModules usage
    inputs.nur.nixosModules.nur
    (
      {
        config,
        inputs,
        ...
      }: let
        cfg = config.crocuda;
      in {
        home-merger = {
          enable = true;
          extraSpecialArgs = {inherit inputs;};
          users = cfg.users;
          modules = [
            inputs.nur.hmModules.nur
          ];
        };
      }
    )
    # Base
    ./base/default.nix

    # Network
    ./network/default.nix

    # Terminal
    ./terminal/default.nix

    # Servers
    ./servers/default.nix
    ./cicd/default.nix

    # File Manager
    ./file_manager/default.nix
    # Torrent
    ./torrent/defautlt.nix

    # Ide
    ./ide/default.nix

    # Browser
    ./browser/extra/default.nix
    ./browser/firefox/default.nix
    ./browser/searxng/default.nix

    # Chat
    ./chat/default.nix

    # Finance
    ./finance/default.nix

    # Virtualization tools
    ./virtualization/default.nix

    # AI
    ./llm/default.nix

    # Window manager
    ./wm/base/default.nix
    ./wm/hyprland/default.nix
    ./wm/gnome/default.nix

    # Streaming
    ./stream/default.nix
  ];
}
