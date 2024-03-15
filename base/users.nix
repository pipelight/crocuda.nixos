{
  config,
  pkgs,
  ...
}: let
  cfg = config.crocuda;
in {
  # Create normal unpriviledged users based on a provided list of names.
  #
  # Usage
  # ```nix
  # services.base = {
  #  enable = true;
  #  users = ["alice", "bob"]
  # };
  # ```
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
