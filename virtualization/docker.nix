{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
  mkIf config.crocuda.virtualization.docker.enable {
    # Enable docker usage
    virtualisation.docker.enable = true;
    # Enable podman usage
    virtualisation.podman.enable = true;

    users.groups = {
      docker.members = config.crocuda.users;
    };

    ## Autostart containers on docker start.
    systemd.services.docker.postStart = ''
      #!${pkgs.bash}
      set +e # Do not exit if a command fails
      echo "Restarting containers..."
      ${pkgs.docker}/bin/docker restart $(${pkgs.docker}/bin/docker ps -a -q)
      exit 0
    '';
  }
