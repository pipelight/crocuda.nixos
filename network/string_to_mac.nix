{
  lib,
  str,
  ...
}: let
in
  with lib;
    mkDerivation {
      name = "string_to_mac";
      builder = ''
        str=$1
        sum=$(echo -n $str | sha256sum)
      '';
      system = builtins.currentSystem;
    }
