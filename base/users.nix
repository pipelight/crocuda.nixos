{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.crocuda;
in {
  # Create normal unpriviledged users
  # from a provided list of names
  users.users = builtins.listToAttrs (
    builtins.map (u: {
      name = u;
      value = {
        isNormalUser = true;
      };
    })
    cfg.users
  );

  nix.settings.trusted-users = ["root"] ++ cfg.users;
}
