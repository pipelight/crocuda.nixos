{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  program.fish.shellInit = ''
    export RAD_PASSPHRASE="$(cat ${config.sops.secrets."radicle/passphrase".path})";
  '';
}
