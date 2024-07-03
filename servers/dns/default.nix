{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.crocuda.servers;
in
  with lib;
    mkIf cfg.dns.enable {
      environment.systemPackages = with pkgs; [
        dig
        ldns # provides "drill"
        unbound
        nsd
      ];
      environment.etc = {
      };

      # Run as dns user
      users.users.dns = {
        isNormalUser = true;
        home = "/home/dns";
      };

      services = {
        unbound = {
          enable = true;
          enableRootTrustAnchor = true;
          checkconf = true;
          settings = {
            # send minimal amount of information to upstream servers to enhance privacy
            qname-minimisation = "yes";
            # easy start, stop and reload
            remote-control.control-enable = true;
            server = {
              interface = ["127.0.0.1"];
            };
            # forward-zone = [
            #   {
            #     name = ".";
            #     forward-addr = "1.1.1.1@853#cloudflare-dns.com";
            #   }
            #   {
            #     name = "example.org.";
            #     forward-addr = [
            #       "1.1.1.1@853#cloudflare-dns.com"
            #       "1.0.0.1@853#cloudflare-dns.com"
            #     ];
            #   }
            # ];
          };
        };
        # nsd = {
        #   enable = true;
        # };
      };
    }
