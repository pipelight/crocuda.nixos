{
  config,
  lib,
  ...
}:
with lib; let
  # cfg = config.networking.privacy;
  nsdEnabled = config.services.nsd.enable;
  keaDDnsEnabled = config.services.kea.dhcp-ddns.enable;
in {
  # enabled on privacy feature only
  # mkIf cfg.enable {
  services = {
    unbound = {
      settings = {
        server = {
          unblock-lan-zones = "yes";
          val-permissive-mode = "yes";

          # send minimal amount of information to upstream.
          hide-identity = "yes";
          hide-version = "yes";
          verbosity = 3;

          interface = [
            "0.0.0.0"
            "::0"
          ];
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
              (mkIf nsdEnabled "127.0.0.1@553")
              (mkIf nsdEnabled "::1@553")

              # VM dns
              # (mkIf keaDDnsEnabled "127.0.0.1@53001")
              # (mkIf keaDDnsEnabled "::1@53001")

              #Mullvad
              "194.242.2.4"
              "2a07:e340::4"
              #Quad9
              "9.9.9.9"
              "2620:fe::fe"
            ];
          }
        ];
      };
    };
  };
}
