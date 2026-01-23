{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  crocuda = {
    users = ["anon"];

    # Servers
    servers = {
      security.enable = true;
      ssh.enable = true;
    };

    # Terminal stuffs
    terminal = {
      shell = {
        fish = {
          enable = true;
          utils.enable = true;
        };
      };
    };
  };
}
