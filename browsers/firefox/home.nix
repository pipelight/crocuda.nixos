{
  config,
  pkgs,
  inputs,
  lib,
  cfg,
  ...
}:
with lib;
  mkIf cfg.office.browser.firefox.enable {
    home.file = {
      # ".config/keepassxc/keepassxc.ini".source = dotfiles/keepassxc/keepassxc.ini;

      # Desktop entry for firefox_i2p
      ".local/share/applications/firefox_i2p.desktop".source = dotfiles/firefox_i2p.desktop;
      ".local/share/applications/firefox_normy.desktop".source = dotfiles/firefox_normy.desktop;
      ".config/tridactyl".source = dotfiles/tridactyl;
    };

    programs.firefox = {
      enable = true;
      # package = pkgs.librewolf;

      # native tridactyl support
      nativeMessagingHosts = [pkgs.tridactyl-native];

      ## Enable arkenfox user.js
      arkenfox = {
        enable = true;
        version = "133.0";
      };

      profiles = let
        extensions = {
          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            darkreader
            ublock-origin
            keepassxc-browser
            tridactyl
            privacy-badger
            # tranquility
            # rust-search-extension
          ];
        };

        # Get every susbsection number
        # jq 'keys' arkenfox-nixos/autogen/122.0.json
        arkenfox = {
          enable = true;
          "0000".enable = true;
          "0100".enable = true;
          "0200".enable = true;
          "0300".enable = true;
          "0400".enable = true;
          "0600".enable = true;
          "0700".enable = true;
          "0800".enable = true;
          "0900".enable = true;
          "1000".enable = true;
          "1200".enable = true;
          "1600".enable = true;
          "1700".enable = true;
          "2000".enable = true;
          "2400".enable = true;
          "2600".enable = true;
          "2700".enable = true;
          "2800".enable = true;
          "4000".enable = true;
          "4500".enable = true;
          "5000".enable = true;
          "5500".enable = true;
          "6000".enable = true;
          "7000".enable = true;
          "8000".enable = true;
          "9000".enable = true;
        };

        # Search engines
        search = {
          force = true;
          default = "SearxNG";
          order = [
            "SearxNG"
            "ddg"
          ];
          engines = {
            # Local search engine
            "SearxNG" = {
              urls = [{template = "http://127.0.0.1:8888/?q={searchTerms}";}];
              icon = "http://127.0.0.1:8888/static/themes/simple/img/favicon.svg";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = ["@searx"];
            };

            # Nix engines
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@nixp"];
            };

            "My NixOS" = {
              urls = [{template = "https://mynixos.com/search?q={searchTerms}";}];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@nixs"];
            };

            "NixOS Wiki" = {
              urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@nixw"];
            };

            "Docs.rs" = {
              urls = [{template = "http://docs.rs/releases/search?query={searchTerms}";}];
              icon = "https://docs.rs/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = ["@rust"];
            };

            # Common engines
            "wikipedia".metaData.alias = "@wiki";

            # Torrent
            "Nyaa" = {
              urls = [{template = "https://nyaa.si/?q={searchTerms}";}];
              icon = "https://nyaa.si/static/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = ["@nyaa"];
            };

            # Remove shity search engines
            "google".metaData.hidden = true;
            "amazondotcom-us".metaData.hidden = true;
            "amazondotnl".metaData.hidden = true;
            "bing".metaData.hidden = true;
            "ebay".metaData.hidden = true;
            "ecosia".metaData.hidden = true;
          };
        };
      in {
        default = {
          inherit extensions;
          inherit arkenfox;
          inherit search;
          userChrome = builtins.readFile dotfiles/userChrome.css;
          isDefault = true;
          id = 0;
        };
        i2p = {
          inherit extensions;
          inherit arkenfox;
          inherit search;
          userChrome = builtins.readFile dotfiles/userChrome_alt.css;
          isDefault = false;
          id = 1;
          settings = {
            "dom.security.https_only_mode" = lib.mkForce false;
            "media.peerconnection.ice.proxy_only" = true;
            "network.proxy.type" = 1;
            "network.proxy.http" = "127.0.0.1";
            "network.proxy.http_port" = 4444;
            "network.proxy.ssl" = "127.0.0.1";
            "network.proxy.ssl_port" = 4444;
          };
        };
        normy = {
          inherit extensions;
          inherit search;
          userChrome = builtins.readFile dotfiles/userChrome_normy.css;
          isDefault = false;
          id = 2;
        };
      };
    };
  }
