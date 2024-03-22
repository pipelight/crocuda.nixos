{
  config,
  pkgs,
  ...
}: let
  cfg = config.crocuda;
in {
  environment.systemPackages = with pkgs; [
    # Decentralized code collaboration plateform
    radicle-cli
  ];
}
