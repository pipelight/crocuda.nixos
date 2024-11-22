{
  config,
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

    #########################
    ## Network and connectivity
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
      emulators.kitty.enable = mkEnableOption ''
        Toggle the module
      '';
      editors = {
        neovim.enable = mkEnableOption ''
          Install base neovim with the specified keyboard layout
        '';
        nvchad.enable = mkEnableOption ''
          Install lightweight nvchad(neovim) with the specified keyboard layout
        '';
        nvchad-ide.enable = mkEnableOption ''
          Install nvchad(neovim) with the specified keyboard layout
          and complete ide extensions
        '';
      };
      # Set shell with the specified keyboard layout
      shell = {
        utils.enable = mkEnableOption ''
          Add command line utils for fast navigation and comfort
        '';
        fish.enable = mkEnableOption ''
          Toggle the module
        '';
      };
      cicd.enable = mkEnableOption ''
        Enable lightweight cicd tools
      '';
      file_manager.enable = mkEnableOption ''
        Toggle the module
      '';
      torrent.enable = mkEnableOption ''
        Toggle the module
      '';
      ##########################
      ## The AI crap
      llm = {
        ollama = {
          enable = mkEnableOption ''
            Toggle the ollama server
          '';
        };
      };
    };

    #########################
    ## Virtualization
    virtualisation = {
      cloud-hypervisor = {
        enable = mkEnableOption ''
          Install cloud-hypervisor (VMM)
        '';
      };
      openvswitch = {
        enable = mkEnableOption ''
          Install openvswitch network manager
        '';
      };
      virshle = {
        enable = mkEnableOption ''
          Install virshle hypervisor as libvirt replacement
        '';
      };
      libvirt = {
        enable = mkEnableOption ''
          Toggle libvirt usage
        '';
      };
      docker = {
        enable = mkEnableOption ''
          Enable docker containerisation engine
        '';
      };
      cloud-init = {
        enable = mkEnableOption ''
          Enable pipelight as cloud-init replacement
        '';
      };
    };

    #########################
    ## Severs
    ## Polished one liner server configs
    servers = {
      logs.enable = mkEnableOption ''
        Toggle rsyslog and logrotate
      '';
      social = {
        mastodon.enable = mkEnableOption ''
          Enable mastodon with bird Ui.
        '';
      };
      web = {
        dns = {
          enable = mkEnableOption ''
            Enable complete secured dns suite
            (unbound + nsd).
          '';
        };
        # Deprecated
        jucenit.enable = mkEnableOption ''
          Enable jucenit web engine.
        '';
        sozu.enable = mkEnableOption ''
          Enable sozu proxy server.
        '';
        pebble.enable = mkEnableOption ''
          Enable pebble, the acme validation test suite.
        '';
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
        # Deprecated
        soft = {
          enable = mkEnableOption ''
            Toggle the module
          '';
        };
        # Deprecated
        charm = {
          enable = mkEnableOption ''
            Toggle the module
          '';
        };
      };
    };

    #########################
    ## Window manager
    # Heavily customed hypr
    wm = {
      hyprland.enable = mkEnableOption ''
        Toggle the hyprland window manager
      '';
      gnome.enable = mkEnableOption ''
        Toggle gnome desktop environment
      '';
    };

    #########################
    ## Office
    # The desktop stuffs that you usualy don't want in a vm
    office = {
      enable = mkEnableOption ''
        Enable small office utilities
      '';
      printers.enable = mkEnableOption ''
        Enable printers and scanners
      '';
      draw.enable = mkEnableOption ''
        Enable printers and scanners
      '';
      video-editing.enable = mkEnableOption ''
        Enable printers and scanners
      '';
      stream.enable = mkEnableOption ''
        Toggle streaming module
      '';
      gaming.enable = mkEnableOption ''
        Enable some emulators
      '';
      yubikey.enable = mkEnableOption ''
        Toggle the module
      '';
      chat = {
        enable = mkEnableOption ''
          Toggle libvirt usage
        '';
      };
      browser = {
        firefox = {
          enable = mkEnableOption ''
            Toggle the module
          '';
          i2p.enable = mkEnableOption ''
            Enable firefox i2p profile
          '';
        };
        searxng = {
          enable = mkEnableOption ''
            Toggle the module
          '';
        };
      };
    };

    #########################
    ## DeFi
    # Always fun to run a node for the community
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
  };

  imports = [
    ######################
    # Modules

    # Add single top level import of NUR (Nixos User repository)
    # for nixosModules usage
    # and for inner hmModules usage
    inputs.nur.nixosModules.nur
    # Lix
    inputs.lix-module.nixosModules.default
    # Tidy
    inputs.nixos-tidy.nixosModules.home-merger # replaces home-manager import

    inputs.nixos-tidy.nixosModules.allow-unfree

    inputs.impermanence.nixosModules.impermanence

    # Network
    inputs.nnf.nixosModules.default

    inputs.jucenit.nixosModules.jucenit

    ({
      config,
      lib,
      pkgs,
      inputs,
      ...
    }: {
      imports = inputs.nixos-tidy.umport {
        # User specific
        paths = [./.];
      };
    })
    # ({
    #   config,
    #   lib,
    #   pkgs,
    #   inputs,
    #   ...
    # }: let
    #   cfg = config.crocuda;
    # in {
    #   home-merger = {
    #     enable = true;
    #     extraSpecialArgs = {inherit inputs;};
    #     users = cfg.users;
    #     modules =
    #       [
    #         inputs.nur.hmModules.nur
    #       ]
    #       ++ inputs.nixos-tidy.umport-home {
    #         paths = [./.];
    #       };
    #   };
    # })
  ];
}
