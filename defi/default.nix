{
  config,
  pkgs,
  lib,
  inputs,
  system,
  ...
}: let
  darkfi = inputs.darkfi.packages.${system}.default;
in {
  boot.kernelParams = ["nr_hugepages=102400"];

  allow-unfree = [
    # "exodus"
  ];

  environment.systemPackages = with pkgs; [
    # Darkfi suit
    # darkfi

    # Wallet
    # exodus

    # Mining
    xmrig
    p2pool
    monero-cli
  ];

  environment.etc = {
    # monero node conf
    "monero/monerod.conf".source = dotfiles/monero/monerod.conf;
  };

  ## Darkirc messaging background service
  systemd.user.services."darkirc" = {
    enable = false;
    after = ["network.target"];
    serviceConfig = {
      ExecStart = "${darkfi}/bin/darkirc";
    };
    wantedBy = ["multi-user.target"];
  };

  users.users.monero = {
    isNormalUser = true;
    home = "/mnt/HDD/monero";
  };
  # Run monero node
  systemd.services."monerod" = {
    enable = false;
    after = ["network.target"];
    serviceConfig = {
      ExecStart = "${pkgs.monero-cli}/bin/monerod --non-interactive";
      User = "monero";
      Group = "users";
      Type = "simple";
      WorkingDirectory = "~";
      StateDirectory = "monero";
      LogsDirectory = "monero";
    };
    wantedBy = ["multi-user.target"];
  };
  # Mine monero (validation node)
  services.xmrig = {
    enable = false;
    settings = {
      autosave = true;
      cpu = true;
      opencl = false;
      cuda = false;
      pools = [
        {
          url = "pool.supportxmr.com:443";
          user = "your-wallet";
          keepalive = true;
          tls = true;
        }
      ];
    };
  };
}
