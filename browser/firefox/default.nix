{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in {
  # Browsh
  # A tui browser based on firefox
  # with experimental vim-mode
  nixpkgs.overlays = [
    (
      final: prev: {
        browsh-vim = pkgs.browsh.overrideAttrs (oldAttrs: rec {
          src = prev.fetchFromGitHub {
            owner = "browsh-org";
            repo = "browsh";
            rev = "refs/heads/vim-mode-exprimental";
            hash = "sha256-KbBVcNuERBL94LuRx872zpjQTzR6c5GalsBoNR52SuQ=";
          };
        });
      }
    )
  ];

  # User specific
  home-merger = {
    enable = true;
    users = cfg.users;
    modules = [
      inputs.arkenfox.hmModules.arkenfox
      ./home.nix
    ];
  };

  programs.firefox = {
    enable = true;
    policies = {
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      # Disable pasword manager
      PasswordManagerEnabled = false;
      OfferToSaveLoginsDefault = false;

      DisableTelemetry = true;
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableAccounts = true;
      DisableFirefoxScreenshots = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DontCheckDefaultBrowser = true;
      DisplayMenuBar = "default-off";
      SearchBar = "unified";
      NoDefaultBookmarks = true;
      DisplayBookmarksToolbar = "never";
      Preferences = let
        lock-false = {
          Value = false;
          Status = "locked";
        };
        lock-true = {
          Value = true;
          Status = "locked";
        };
        lock-empty-string = {
          Value = "";
          Status = "locked";
        };
      in {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = lock-true;

        # Remove poluting defaults
        "extensions.pocket.enabled" = lock-false;

        # Remove default top sites
        "browser.topsites.contile.enabled" = lock-false;
        "browser.urlbar.suggest.topsites" = lock-false;

        # Remove sponsored sites
        "browser.newtabpage.pinned" = lock-empty-string;
        "browser.newtabpage.activity-stream.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;

        # Remove firefox shiny buttons
        "browser.tabs.firefox-view" = false;
        "browser.tabs.firefox-view-next" = false;
        # Style
        "browser.compactmode.show" = lock-true;
        "browser.uidensity" = {
          Value = 1;
          Status = "locked";
        };
        # Fonts - make web pages follow system font
        "browser.display.use_document_fonts" = {
          Value = 0;
          Status = "locked";
        };
      };
    };
  };
}
