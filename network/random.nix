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
          # "net.ipv6.conf.all.use_tempaddr" = 1;
        };
      };

      ## NetworkManager
      networking.networkmanager = {
        enable = true;
        dns = "none";
        dhcp = "internal";
        connectionConfig = {
          # MAC address randomization
          "ethernet.cloned-mac-address" = "random";
          "wifi.cloned-mac-address" = "random";

          # Random inbound
          "ipv6.addr-gen-mode" = "stable-privacy";
          # Random outbound
          "ipv6.ip6-privacy" = 2;
        };
        logLevel = "INFO";
      };
    }
