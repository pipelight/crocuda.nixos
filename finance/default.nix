{
  config,
  pkgs,
  lib,
  inputs,
  system,
  ...
}: let
  cfg = config.crocuda;
in {
  boot.kernelParams = ["nr_hugepages=102400"];

  allow-unfree = [
    # "exodus"
  ];

  # User specific
  home-merger = {
    enable = true;
    users = cfg.users;
    modules = [
      inputs.nur.hmModules.nur
      inputs.arkenfox.hmModules.arkenfox
      ./home.nix
    ];
  };

  environment.systemPackages = with pkgs; [
    # Mining
    xmrig
    p2pool
    monero-cli
  ];

  users.users.monero = {
    isNormalUser = true;
    home = "/mnt/HDD/monero";
  };

  environment.etc = {
    # monero node conf
    "monero/monerod.conf".source = dotfiles/monero/monerod.conf;
  };

  # Run monero node
  systemd.services."monerod" = {
    enable = false;
    after = ["network.target"];
    serviceConfig = {
      ExecStart = "${pkgs.monero-cli}/bin/monerod --non-interactive --prune-blockchain";
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
