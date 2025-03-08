{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.crocuda;

  # Generate a 128bits hash from a string
  str_to_hash = string:
    builtins.substring 0 32 (builtins.hashString "sha256" string);

  # Generate an ipv6 from a string
  str_to_ipv6 = string: let
    hash = str_to_hash string;
    step = 4;
  in
    lib.concatStringsSep ":" (
      lib.forEach (lib.range 0 (lib.stringLength hash / 4 - 1)) (
        i: builtins.substring (i * step) step hash
      )
    );

  str_to_iid = string: let
    hash = str_to_hash string;
    step = 4;
  in
    lib.concatStringsSep ":" (
      lib.forEach (lib.range (4 - 1) (lib.stringLength hash / 4 - 1)) (
        i: builtins.substring (i * step) step hash
      )
    );
in
  lib.mkIf (cfg.network.privacy.enable
    && cfg.network.privacy.strategy
    == "fixed") {
    ##########################
    # Force usage of ipv6 privacy extension in
    # - kernel parameters (low level)
    # - networkmanager (high level)

    # Ensure directory is writable
    # for sysctl to apply kernel network config
    systemd.tmpfiles.rules = [
      "d '/proc/sys/net' 755 root root - -"
    ];

    ## Kernel
    boot = {
      # kernelParams = ["IPv6PrivacyExtensions=1"];
      kernel.sysctl = let
        ipv6 = str_to_ipv6 cfg.network.privacy.secret;
      in {
        # Enable maximal privacy extensions
        "net.ipv6.conf.all.use_tempaddr" = lib.mkForce 2;
        "net.ipv6.conf.default.use_tempaddr" = 2;

        # Generate random ipv6
        "net.ipv6.conf.default.gen_mode" = "stable-privacy";
        "net.ipv6.conf.all.gen_mode" = "stable-privacy";

        # Set secret to hashed string
        "net.ipv6.conf.default.stable_secret" = ipv6;
        "net.ipv6.conf.all.stable_secret" = ipv6;
      };
    };

    ##########################
    # You should use either systemd-networkd OR NetworkManager.

    ## Both use the external dhcpcd.
    ## dhcpcd
    networking.dhcpcd = {
      extraConfig = ''
        slaac private
      '';
    };

    ## system-networkd
    ## Can't set pri
    systemd.network.config = ''
      [Network]
      DHCP=yes
      IPv6PrivacyExtensions=kernel
    '';

    ## NetworkManager
    networking.networkmanager = {
      dns = "none";
      dhcp = "dhcpcd";
      connectionConfig = {
        # MAC address randomization
        "ethernet.cloned-mac-address" = "random";
        "wifi.cloned-mac-address" = "random";

        # Fixed inbound
        "ipv6.addr-gen-mode" = "default";
        "ipv6.token" = str_to_iid cfg.network.privacy.secret;

        # Random outbound
        "ipv6.ip6-privacy" = 2;
      };
      logLevel = "INFO";
    };
  }
