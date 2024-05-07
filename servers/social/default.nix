{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in
  with lib;
    mkIf cfg.servers.social.mastodon.enable {
      # security.acme = {
      #   acceptTerms = true;
      #   defaults.email = "<EMAIL TO USE FOR CORRESPONDENCE WITH Let's Encrypt>";
      # };
      services.mastodon = {
        enable = true;
        localDomain = "social.example.com"; # Replace with your own domain
        configureNginx = false;
        smtp.fromAddress = "noreply@social.example.com"; # Email address used by Mastodon to send emails, replace with your own
        extraConfig.SINGLE_USER_MODE = "true";
      };
    }
