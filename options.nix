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

    #########################
    ## Network and connectivity
    network = {
      bluetooth.enable = mkEnableOption ''
        Enable bluetooth with Playstation remote controller fixes.
      '';
      tools.enable = mkEnableOption ''
        Add some network troubleshooting tools.
      '';
      multicast-forwarding.enable = mkEnableOption ''
        Enable kernel ipv6 multicast forwarding.
      '';
    };

    #########################
    ## Severs
    ## Polished one liner server configs
    servers = {
      atuin.enable = mkEnableOption ''
        Toggle atuin server.
      '';
      security.enable = mkEnableOption ''
        Toggle security features
      '';
      logs.enable = mkEnableOption ''
        Toggle rsyslog and logrotate
      '';
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
        letsencrypt = {
          enable = mkEnableOption ''
            Enable automatic certificate generation for the folowing domains
          '';
          domains = mkOption {
            type = with types; let
              t = listOf str;
            in
              attrsOf t;
            description = ''
              List of domain which to generate ssl for.
              With certbot and cron jobs.
            '';
            default = {
              example.com = ["example.com"];
            };
          };
        };
        sozu = {
          config = mkOption {
            type = with types; attrs;
            description = "sozu configuration";
          };
          enable = mkEnableOption ''
            Enable sozu the tcp/http server proxy .
          '';
        };
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
      niri = {
        enable = mkEnableOption ''
          Toggle the hyprland window manager
        '';
      };
      hyprland = {
        enable = mkEnableOption ''
          Toggle the hyprland window manager
        '';
        mode = mkOption {
          type = with types; enum ["bspwm" "niri"];
          description = ''
            The default window manager tilling behavior
          '';
          default = "niri";
        };
        wide = mkEnableOption ''
          Convenient window splits for ultrawide monitors
        '';
      };
      gnome = {
        enable = mkEnableOption ''
          Toggle the gnome desktop environment.
        '';
        flatpak.enable = mkEnableOption ''
          Toggle flatpak and flathub package management.
        '';
      };
    };

    #########################
    ## Office
    # The desktop stuffs that you usualy don't want in a vm
    office = {
      browser = {
        firefox = {
          enable = mkEnableOption ''
            Toggle the module
          '';
          i2p.enable = mkEnableOption ''
            Enable firefox profile for i2p browsing.
          '';
        };
        searxng = {
          enable = mkEnableOption ''
            Toggle searx local search engine.
          '';
        };
      };
      chat = {
        enable = mkEnableOption ''
          Toggle signal, element, mails...
        '';
      };
      write.enable = mkEnableOption ''
        Enable libre/open office sute
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
      android = {
        enable = mkEnableOption ''
          Android tooling
        '';
      };
    };

    #########################
    ## DeFi
    # Always fun to run a node for the community
    finance = {
      dex = {
        enable = mkEnableOption ''
          Enable multichain Dex and Wallet.
        '';
      };
      monero = {
        enable = mkEnableOption ''
          Run a local monero node.
        '';
        mining = {
          enable = mkEnableOption ''
            Toggle monero mining.
          '';
        };
      };
      wownero = {
        enable = mkEnableOption ''
          Run a local wownero node.
        '';
        mining = {
          enable = mkEnableOption ''
            Toggle wownero mining.
          '';
        };
      };
      darkfi = {
        enable = mkEnableOption ''
          Run a local darkfi node.
        '';
      };
    };
  };
}
