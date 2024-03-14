{
  config,
  pkgs,
  ...
}: {
  home.stateVersion = "23.05"; # Please read the comment before changing.

  home.file = {
    "soft/config.yaml".source = dotfiles/soft/config.yaml;
    "soft/env".source = dotfiles/soft/env;
    "charm.conf".source = dotfiles/charm/charm.conf;
  };
}
