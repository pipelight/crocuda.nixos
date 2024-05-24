{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  main_cfg = config.crocuda;
  cfg = {
    user = "unit";
    group = "unit";
    stateDir = "/var/spool/unit";
    logDir = "/var/log/unit/";
  };
in
  with lib;
    mkIf main_cfg.servers.web.unit.enable {
      users.users.unit = {
        group = "unit";
        isSystemUser = true;
      };
      users.groups = {
        unit.members = main_cfg.users;
      };

      environment.defaultPackages = with pkgs; [
        # Vercel server anything
        nodePackages.serve
        inputs.jucenit.packages.${system}.default

        # Web server and dependencies
        unit
        deno
        openssl
        certbot
      ];
      systemd.tmpfiles.rules = [
        "d '${cfg.stateDir}' 0750 ${cfg.user} ${cfg.group} - -"
        "Z '${cfg.stateDir}' 0750 ${cfg.user} ${cfg.group} - -"
        "d '${cfg.logDir}' 0750 ${cfg.user} ${cfg.group} - -"
        "Z '${cfg.logDir}' 0750 ${cfg.user} ${cfg.group} - -"
      ];

      ## Add global packages
      # services.unit.enable = true; # Do not use because overkilling config file

      ## Custom systemd unit
      # Replace default secure unix socket with local tcp socket
      # source at: https://github.com/NixOS/nixpkgs/nixos/modules/services/web-servers/unit/default.nix
      systemd.services.unit = {
        enable = true;
        after = ["network.target"];
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          Type = "forking";
          PIDFile = "/run/unit/unit.pid";
          ExecStart = ''
            ${pkgs.unit}/bin/unitd \
              --control '127.0.0.1:8080' \
              --pid '/run/unit/unit.pid' \
              --log '${cfg.logDir}/unit.log' \
              --statedir '${cfg.stateDir}' \
              --tmpdir '/tmp' \
              --user unit \
              --group unit
          '';
          # Runtime directory and mode
          RuntimeDirectory = "unit";
          RuntimeDirectoryMode = "0750";
          # Access write directories
          ReadWritePaths = [cfg.stateDir cfg.logDir];
          # Security
          NoNewPrivileges = true;
          # Sandboxing
          ProtectSystem = "strict";
          ProtectHome = true;
          PrivateTmp = true;
          PrivateDevices = true;
          PrivateUsers = false;
          ProtectHostname = true;
          ProtectClock = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          ProtectControlGroups = true;
          RestrictAddressFamilies = ["AF_UNIX" "AF_INET" "AF_INET6"];
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          PrivateMounts = true;
          # System Call Filtering
          SystemCallArchitectures = "native";
        };
      };
    }
