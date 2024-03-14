{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    ## Password managers
    keepassxc
    gnupg
  ];

  home.file = {
    # ".config/keepassxc/keepassxc.ini".source = dotfiles/keepassxc/keepassxc.ini;
  };
}
