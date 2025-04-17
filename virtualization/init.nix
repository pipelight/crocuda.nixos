{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in
  with lib;
    mkIf cfg.virtualization.pipelight-init.enable {
      systemd.services.pipelight-init = {
        enable = true;
        description = "Run pipelight as a cloud-init replacement";
        after = ["network.target"];
        wantedBy = ["multi-user.target"];
        # Starts only if mountpoint detected
        unitConfig = {
          ConditionPathExists = "/pipelight-init";
        };
        serviceConfig = {
          Type = "oneshot";
          Environment = "PATH=/run/current-system/sw/bin";
          ExecStart = with pkgs; let
            package = inputs.pipelight.packages.${system}.default;
          in ''
            rm ./.pipelight
            ${package}/bin/pipelight run init --attach -vvv
          '';
          WorkingDirectory = "/pipelight-init";
          StandardInput = "null";
          StandardOutput = "journal+console";
          StandardError = "journal+console";
        };
      };
    }
