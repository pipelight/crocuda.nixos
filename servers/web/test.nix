{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
  pebbleConfig = pkgs.writeText "pebble.json" (builtins.toJSON {
    pebble = {
      listenAddress = "127.0.0.1:14000";
      managementListenAddress = "127.0.0.1:15000";
      certificate = "/etc/pebble/cert.pem";
      privateKey = "/etc/pebble/key.pem";
      httpPort = 5002;
      tlsPort = 5001;
      ocspResponderURL = "";
      externalAccountBindingRequired = false;
    };
  });
  pebble_gen_certs = pkgs.writeShellScriptBin "pebble_gen_certs" ''
    minica -ca-cert /etc/pebble/cert.pem \
           -ca-key /etc/pebble/key.pem \
           -domains localhost,pebble \
           -ip-addresses 127.0.0.1
    chmod +r /etc/pebble/*
  '';
in
  with lib;
    mkIf cfg.servers.web.pebble.enable {
      environment.defaultPackages = with pkgs; [
        # https://github.com/letsencrypt/pebble
        pebble
        minica
        # Run before runnig pebble
        pebble_gen_certs
      ];
      # SSL suport
      # security.acme = {
      #   acceptTerms = true;
      #   defaults.email = "admin+acme@example.org";
      # };

      # Open ports in the firewall.
      # networking.firewall.allowedTCPPorts = [ ... ];

      systemd.services.pebble-challtestsrv = {
        description = "Pebble ACME Challenge Test Server";
        after = ["network-online.target"];
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          Environment = ["PEBBLE_VA_NOSLEEP=1" "PEBBLE_VA_ALWAYS_VALID=1"];
          ExecStart = "${pkgs.pebble}/bin/pebble-challtestsrv";
          DynamicUser = true;
        };
      };
      systemd.services.pebble = {
        description = "Pebble ACME Test Server";
        after = ["network-online.target"];
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          Environment = ["PEBBLE_VA_NOSLEEP=1" "PEBBLE_VA_ALWAYS_VALID=1"];
          ExecStart = "${pkgs.pebble}/bin/pebble -config ${pebbleConfig}";
          DynamicUser = true;
        };
      };
    }
