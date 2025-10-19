{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  # Automatically generate all secrets required by services.
  # The secrets are stored in /etc/nix-bitcoin-secrets
  nix-bitcoin.generateSecrets = true;

  # Enable some services.
  # See ../configuration.nix for all available features.
  services.bitcoind.enable = true;
  services.clightning.enable = true;

  # When using nix-bitcoin as part of a larger NixOS configuration, set the following to enable
  # interactive access to nix-bitcoin features (like bitcoin-cli) for your system's main user
  nix-bitcoin.operator = {
    enable = true;
    # FIXME: Set this to your system's main user
    name = "anon";
  };

  services.btcpayserver = {
    enable = true;
    address = "::1";
    package = pkgs.btcpayserver-altcoins;
  };
}
