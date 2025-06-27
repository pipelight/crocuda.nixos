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
      systemd.services.pipelight-init_pre = {
        enable = true;
        description = "Run pipelight as a cloud-init replacement";
        before = ["network.target"];
        wantedBy = ["multi-user.target"];
        # Starts only if mountpoint detected
        unitConfig = {
          ConditionPathExists = "/pipelight-init";
        };
        serviceConfig = with pkgs; let
          package = inputs.pipelight.packages.${system}.default;
        in {
          Type = "oneshot";
          User = "root";
          Group = "users";
          Environment = "PATH=/run/current-system/sw/bin";
          ExecStartPre = "-${package}/bin/pipelight logs rm";
          ExecStart = ''
            ${package}/bin/pipelight run init_pre --attach -vvv
          '';
          WorkingDirectory = "/pipelight-init";
          StandardInput = "null";
          StandardOutput = "journal+console";
          StandardError = "journal+console";
        };
      };
      systemd.services.pipelight-init_post = {
        enable = true;
        description = "Run pipelight as a cloud-init replacement.";
        after = ["network.target"];
        wantedBy = ["multi-user.target"];
        # Starts only if mountpoint detected
        unitConfig = {
          ConditionPathExists = "/pipelight-init";
        };
        serviceConfig = with pkgs; let
          package = inputs.pipelight.packages.${system}.default;
        in {
          Type = "oneshot";
          User = "root";
          Group = "users";
          Environment = "PATH=/run/current-system/sw/bin";
          ExecStartPre = "-${package}/bin/pipelight logs rm";
          ExecStart = ''
            ${package}/bin/pipelight run init_post --attach -vvv
          '';
          WorkingDirectory = "/pipelight-init";
          StandardInput = "null";
          StandardOutput = "journal+console";
          StandardError = "journal+console";
        };
      };
    }
