{
  config,
  pkgs,
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
      type = with types; listOf str;
      description = ''
        The name of the user for whome to add this module.
      '';
      default = ["anon"];
    };

    network = {
      privacy.enable = mkEnableOption ''
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
    };

    llm = {
      oatmeal = {
        enable = mkEnableOption ''
          Toggle the module
        '';
      };
    };

    virtualization = {
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
      web = {
        unit.enable = mkEnableOption ''
          Nginx unit web server.
        '';
        caddy.enable = mkEnableOption ''
          Caddy web server.
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
            default = ["anon"];
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
  };

  imports = [
    inputs.impermanence.nixosModules.impermanence

    inputs.nixos-utils.nixosModules.home-merger
    inputs.nixos-utils.nixosModules.allow-unfree

    # Add single top level import of NUR
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

    # File Manager
    ./file_manager/default.nix

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
  ];
}
