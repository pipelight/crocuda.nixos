{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  environment.etc."sysctl.d/70-crocuda.conf".text = lib.concatStrings (
    lib.mapAttrsToList (
      n: v:
        lib.optionalString (v != null) "${n}=${
          if v == false
          then "0"
          else toString v
        }\n"
    )
    config.boot.kernel.sysctl
  );

  systemd.services.systemd-sysctl = {
    wantedBy = ["multi-user.target"];
    restartTriggers = [config.environment.etc."sysctl.d/70-crocuda.conf".source];
  };
}
