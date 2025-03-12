{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.crocuda;

  unboundEnabled = config.services.unbound.enable;

  ## Functions

  # Generate a 128bits hash from a secret
  str_to_hash = string:
    builtins.substring 0 32 (builtins.hashString "sha256" string);

  # Add a ":" each n(step) characters
  hash_to_address = string: step:
    lib.concatStringsSep ":" (
      lib.forEach (lib.range 0 (lib.stringLength string / step - 1)) (
        i: builtins.substring (i * step) step string
      )
    );

  # Generate a mac address from a sting
  str_to_mac = string: let
    hash = builtins.substring 0 12 (str_to_hash string);
    vec_hash = stringToCharacters hash;

    sanitized_hash = concatStrings (
      imap0 (i: v:
        if i == 1
        then "2" # SLAP quadrant (AAI)
        else v) (stringToCharacters hash)
    );
    step = 2;
    mac = hash_to_address sanitized_hash step;
  in
    mac;

  # Generate an ipv6 from a string
  str_to_ipv6 = string: let
    hash = str_to_hash string;
    step = 4;
    ipv6 = hash_to_address hash step;
  in
    ipv6;

  # Generate an ipv6 iid from a string
  str_to_iid = string: let
    # Take only the iid part of the ipv6
    hash = builtins.substring 16 16 (str_to_hash string);
    step = 4;
    iid = hash_to_address hash step;
  in
    iid;

  ## Globals

  iid = cfg.network.privacy.ipv6.iid;
  computed_iid = str_to_iid cfg.network.privacy.ipv6.secret;
  token =
    if (!isNull iid)
    then iid
    else computed_iid;

  computed_mac = str_to_mac cfg.network.privacy.ipv6.secret;
in
  mkIf (cfg.network.privacy.enable
    && cfg.network.privacy.ipv6.strategy
    == "fixed") {
    ##########################
    # Force usage of ipv6 privacy extension in
    # - kernel parameters (low level)
    # - networkmanager (high level)
    # - systemd-networkd (high level)
    # + dhcp (high level)

    ## Kernel
    boot = {
      kernelParams = ["IPv6PrivacyExtensions=1"];
      # More information about keys possible values at:
      # https://sysctl-explorer.net/net/ipv6/
      kernel.sysctl = {
        # Enable maximal privacy extensions
        "net.ipv6.conf.default.use_tempaddr" = mkForce 2;
        "net.ipv6.conf.all.use_tempaddr" = 2;

        # Generate random ipv6
        # 0 = "eui64"
        # 1 = "eui64"
        # 2 = "stable-privacy" with secret
        # 3 = "stable-privacy" with random secret
        "net.ipv6.conf.default.addr_gen_mode" = 2;
        "net.ipv6.conf.all.addr_gen_mode" = 2;

        # Set secret to hashed string
        "net.ipv6.conf.default.stable_secret" = "::${token}";
      };
    };

    ## dhcpcd
    networking = {
      # Force dhcpcd usage with networkmanager.
      # for tool concistency with servers that do not use networkmanager.
      useDHCP = mkForce true;
      dhcpcd = {
        enable = true; #default
        extraConfig = ''
          nohook resolv.conf
          slaac token ::${token}
        '';
      };
    };

    # networking.resolvconf.extraConfig = ''
    #   lookup file bind
    # '';

    ##########################
    # You should use either systemd-networkd OR NetworkManager.

    ## system-networkd
    systemd.network.config = ''
      [Network]
      DHCP=yes
      IPv6Token=::${token}
    '';

    networking.interfaces = mkIf (!config.networking.networkmanager.enable) {
      end0.macAddress = computed_mac;
      eno1.macAddress = computed_mac;
      ens3.macAddress = computed_mac;
    };
    ## NetworkManager
    # https://www.networkmanager.dev/docs/api/latest
    networking.networkmanager = mkIf config.networking.networkmanager.enable {
      logLevel = "INFO";

      ## Use external dns -> unbound
      dns =
        if unboundEnabled
        then "none"
        else "default";

      ## Use external dhcp -> dhcpcd
      # dhcp = "dhcpcd";
      dhcp = "internal";

      connectionConfig = {
        # MAC address randomization
        # Random on cable link
        "ethernet.cloned-mac-address" = mkForce "random";
        # Random on wifi
        "wifi.cloned-mac-address" = mkForce "random";
      };

      ensureProfiles.profiles = {
        default = {
          connection = {
            id = "wired-fixed";
            type = "ethernet";
          };
          ethernet = {
            cloned-mac-address = computed_mac;
          };
          ipv4 = {
            dns-search = "lan";
            # dns-priority default = 100, vpn = 50
            dns-priority = 20;
            method = "auto";
          };
          ipv6 = {
            dns-search = "lan";
            # dns-priority default = 100, vpn = 50
            dns-priority = 20;
            method = "auto";

            # Fixed inbound ip
            addr-gen-mode = "eui64";
            token = "::${token}";

            # Random outbound ip
            ip6-privacy = 2;
          };
        };
      };
    };
  }
