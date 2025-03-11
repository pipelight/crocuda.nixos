{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib; let
  cfg = config.crocuda;
in
  # enabled on privacy feature only
  mkIf cfg.network.privacy.enable {
    services = {
      enable = true;
      unbound = {
        enableRootTrustAnchor = true;
        checkconf = true;
        settings = {
          server = {
            unblock-lan-zones = "yes";
            val-permissive-mode = "yes";
            private-domain = ["lan"];

            # send minimal amount of information to upstream.
            hide-identity = "yes";
            verbosity = 2;
          };
          remote-control = {
            control-enable = true;
            control-interface = [
              "127.0.0.1"
              "::1"
            ];
          };
          forward-zone = [
            {
              name = ".";
              forward-addr = [
                #Mullvad
                "194.242.2.4"
                "2a07:e340::4"
                #Quad9
                "9.9.9.9"
                "2620:fe::fe"
                "2620:fe::9"
              ];
            }
          ];
        };
      };
    };
  }
