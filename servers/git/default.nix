{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # ./charm/default.nix
    ./radicle/default.nix
  ];
  # Git server
  users.users.git = {
    isNormalUser = true;
    homeMode = "770";
  };
  environment.systemPackages = with pkgs; [
  git
    lazygit
  ];
}
