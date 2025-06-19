{
  lib,
  inputs,
  ...
} @ args: rec {
  dns = import ./dns/zones.nix args;
  hugepages = import ./hugepages/default.nix args;
}
