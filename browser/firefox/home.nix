{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.arkenfox.hmModules.arkenfox
  ];

  home.file = {
    # ".config/keepassxc/keepassxc.ini".source = dotfiles/keepassxc/keepassxc.ini;
    # Desktop entry for firefox_i2p
    ".local/share/applications/firefox_i2p.desktop".source = dotfiles/firefox_i2p.desktop;
  };

  programs.firefox = {
    enable = true;
    ## Enable arkenfox user.js
    arkenfox = {
      enable = true;
      version = "122.0";
    };

    profiles = let
      extensions = with config.nur.repos.rycee.firefox-addons; [
        darkreader
        ublock-origin
        keepassxc-browser
        tridactyl
      ];

      # Set a default userChrome
      userChrome = builtins.readFile dotfiles/userChrome.css;

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
          "DuckDuckGo"
        ];
        engines = {
          # Local search engine
          "SearxNG" = {
            urls = [{template = "http://127.0.0.1:8888/?q={searchTerms}";}];
            iconUpdateURL = "http://127.0.0.1:8888/static/themes/simple/img/favicon.svg";
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
            definedAliases = ["@mynix"];
          };

          "NixOS Wiki" = {
            urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@nixw"];
          };

          # Common engines
          "Wikipedia (en)".metaData.alias = "@wiki";

          # Torrent
          "Nyaa" = {
            urls = [{template = "https://nyaa.si/?q={searchTerms}";}];
            icon = "https://nyaa.si/static/favicon.png";
            iconUpdateURL = "https://nyaa.si/static/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = ["@nyaa"];
          };

          # Remove shity search engines
          "Google".metaData.hidden = true;
          "Amazon.com".metaData.hidden = true;
          "Amazon.nl".metaData.hidden = true;
          "Bing".metaData.hidden = true;
          "eBay".metaData.hidden = true;
        };
      };
    in {
      i2p = {
        inherit extensions;
        userChrome = builtins.readFile dotfiles/userChrome_alt.css;
        inherit arkenfox;
        inherit search;

        isDefault = false;
        id = 1;

        settings = {
          "media.peerconnection.ice.proxy_only" = true;
          "network.proxy.type" = 1;
          "network.proxy.http" = "127.0.0.1";
          "network.proxy.http_port" = 4444;
          "network.proxy.ssl" = "127.0.0.1";
          "network.proxy.ssl_port" = 4444;
        };
      };
      default = {
        inherit extensions;
        inherit userChrome;
        inherit arkenfox;
        inherit search;

        isDefault = true;
      };
    };
  };
}
