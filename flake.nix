{
  description = "crocuda.nixos - Some NixOS configuration modules for paranoids";

  inputs = {
    # Nixos profile
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    # NUR - Nix User Repository
    nur.url = "github:nix-community/NUR";

    nixos-utils.url = "github:pipelight/nixos-utils";

    # Utils
    flake-utils.url = "github:numtide/flake-utils";

    impermanence.url = "github:nix-community/impermanence";

    # Flakes
    pipelight.url = "github:pipelight/pipelight";
    virshle.url = "github:pipelight/virshle";
    ollama.url = "github:havaker/ollama-nix";

    # Server
    mail-server.url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
    arkenfox.url = "github:dwarfmaster/arkenfox-nixos";
  };

  outputs = {nixpkgs, arkenfox,...} @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs;
  in {
    nixosModules = {
      # Default module
      default = {
        config,
        pkgs,
        lib,
        utils,
        ...
      }:
        with inputs;
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
            inputs.nixos-utils.nixosModules.home-merger
            inputs.nixos-utils.nixosModules.allow-unfree
            inputs.impermanence.nixosModules.impermanence

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
        };
    };
  };
}
