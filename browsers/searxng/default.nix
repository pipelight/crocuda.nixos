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
    mkIf cfg.office.browser.searxng.enable {
      environment.systemPackages = with pkgs; [
        ## Search engine
        # A local search engine that gather other search engine results.
        # It anonimise searches by removing cookies and special params.
        # Furthermore no metadata collection (trackers, blueprint..)
        searxng
        # searxng dependencies
        redis
      ];

      ## Searxng background service
      # and redis dependency
      systemd.services."searxng" = {
        enable = true;
        after = ["network.target"];
        serviceConfig = {
          ExecStart = "${pkgs.searxng}/bin/searxng-run";
        };
        wantedBy = ["multi-user.target"];
      };
      services.redis.servers."searxng-redis".enable = true;

      environment.etc = {
        # Searxng configuration file
        "searxng/settings.yml".source = dotfiles/settings.yml;
      };
    }
