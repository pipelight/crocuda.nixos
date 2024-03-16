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

    # Set editors with the specified keyboard layout
    terminal = {
      editor = {
        # Ide
        nvchad.enable = mkEnableOption ''
          Toggle the module
        '';
        vim.enable = mkEnableOption ''
          Toggle the module
        '';
      };
      # Set shell with the specified keyboard layout
      shell = {
        fish.enable = mkEnableOption ''
          Toggle the module
        '';
      };
      file_manager = {
        yazi.enable = mkEnableOption ''
          Toggle the module
        '';
      };
    };

    llm = {
      oatmeal = {
        enable = mkEnableOption ''
          Toggle the module
        '';
      };
    };

    mail = {
      server.enable = mkEnableOption ''
        Toggle the module
      '';
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
          Run local monero node
        '';
      };
    };

    # Window manager
    # Heavily customed hypr
    wm = {
      hyprland = mkEnableOption ''
        Toggle the module
      '';
    };
  };

  imports = [
    # inputs.nur.nixosModules.nur
    # inputs.impermanence.nixosModules.impermanence

    inputs.nixos-utils.nixosModules.home-merger
    inputs.nixos-utils.nixosModules.allow-unfree

    # Add single top level import of NUR
    # for inner home manager usage
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

    # Terminal
    ./terminal/default.nix

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
  ];
}
