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
      tools.enable = mkEnableOption ''
        Add some network troubleshooting tools.
      '';
      multicast-forwarding.enable = mkEnableOption ''
        Enable kernel ipv6 multicast forwarding.
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

    virtualization = {
      docker.enable = mkEnableOption ''
        Toggle atuin server.
      '';
      utils.enable = mkEnableOption ''
        Toggle atuin server.
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
        defaultConfig = mkEnableOption ''
          Security enhanced DNS configuration (unbound + nsd).
          Service still must be enabled.
          `services.nsd.enable = true`
          `services.unbound.enable = true`
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
            Enable Sozu the tcp/http proxy .
          '';
        };
        ferron = {
          config = mkOption {
            type = with types; attrs;
            description = "ferron configuration";
          };
          enable = mkEnableOption ''
            Enable Ferron the tcp/http webserver + proxy.
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
