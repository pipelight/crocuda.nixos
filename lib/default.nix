{
  lib,
  inputs,
  ...
} @ args: rec {
  dns = import ./dns/zones.nix args;
  ip = import ./network/ip.nix args;
}
