{
  lib,
  inputs,
  ...
} @ args: rec {
  dns = import ./dns/zones.nix args;
}
