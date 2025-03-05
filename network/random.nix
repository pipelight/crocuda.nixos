{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.crocuda;
in
  with lib;
    mkIf (cfg.network.privacy.enable
      && cfg.network.privacy.strategy
      == "random") {
      ##########################
      # Force usage of ipv6 privacy extension in
      # - kernel parameters (low level)
      # - networkmanager (high level)

      ## Kernel
      boot = {
        kernelParams = ["IPv6PrivacyExtensions=1"];
        kernel.sysctl = {
          "net.ipv6.conf.all.use_tempaddr" = 1;
        };
      };

      ## NetworkManager
      networking.networkmanager = {
        enable = true;
        dns = "none";
        dhcp = "internal";
        connectionConfig = {
          # "ethernet.cloned-mac-address" = mkDefault "random";
          # "ipv4.ignore-auto-dns" = mkDefault "yes";
          "wifi.cloned-mac-address" = mkDefault "random";
          "ipv6.ip6-privacy" = mkDefault "2";
        };
        logLevel = "INFO";
      };
    }
