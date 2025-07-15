{config, ...}: let
  cfg = config.crocuda;
  keaDDnsEnabled = config.services.kea.dhcp-ddns.enable;
in {
  ## dns resolver/caching
  services.hickory-dns = {
    debug = true;
    settings = {
      listen_addrs_ipv4 = "127.0.0.1";
      listen_addrs_ipv6 = "::1";
      listen_port = "::53";
    };
  };
}
