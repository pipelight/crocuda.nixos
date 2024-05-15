{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in {

  environment.defaultPackages = with pkgs; [
    pebble
  ];

  # SSL suport
  # security.acme = {
  #   acceptTerms = true;
  #   defaults.email = "admin+acme@example.org";
  # };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];

  systemd.services.pebble = let
  pebbleConfig = pkgs.writeText "pebble.json" (builtins.toJSON {
    pebble = {
      listenAddress = "0.0.0.0:14000";
      managementListenAddress = "0.0.0.0:15000";
      certificate = "${pkgs.pebble.src}/test/certs/localhost/cert.pem";
      privateKey = "${pkgs.pebble.src}/test/certs/localhost/key.pem";
      httpPort = 5002;
      tlsPort = 5001;
      ocspResponderURL = "";
      externalAccountBindingRequired = false;
    };
  });
in {
    description = "Pebble ACME Test Server";
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Environment = [ "PEBBLE_VA_NOSLEEP=1" "PEBBLE_VA_ALWAYS_VALID=1" ];
      ExecStart = "${pkgs.pebble}/bin/pebble -config ${pebbleConfig}";
      DynamicUser = true;
    };
  };
}
