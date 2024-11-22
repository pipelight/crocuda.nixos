{
  config,
  pkgs,
  inputs,
  ...
}: {
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
