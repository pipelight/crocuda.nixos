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
    mkIf cfg.virtualization.libvirt.enable {
      # Import home file
      home-merger = {
        enable = true;
        extraSpecialArgs = {inherit pkgs inputs;};
        users = cfg.users;
        modules = [
          ./home.nix
        ];
      };

      environment.systemPackages = with pkgs; [
        # libvirt things
        unscd
        # Build images based on flakes and local config
        nixos-generators
        cdrkit
        # A VM deployment tool
        colmena
        # Virshle from the flake
        # and dependencies
        # inputs.virshle.packages.${system}.default
        # Tool to easily create volumes(qcow)
        libguestfs
        guestfs-tools
        deno
      ];

      # Enable docker usage
      virtualisation.docker.enable = true;

      # Do not support efi boot
      # virtualisation.xen = {
      #   enable = false;
      # };
      # Enable libvirt virtualization framework
      virtualisation.libvirtd = {
        enable = true;
        # A name server to map VM ip to its name defined with libvirt
        # Allows this: `ssh vm_nixos`
        nss = {
          enable = true;
          enableGuest = true;
        };
        extraOptions = [
          "--verbose"
        ];
        allowedBridges = [
          "virbr0"
          "virbr2"
          "virbr4"
          "virbr6"
        ];

        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
          swtpm.enable = true;
          ovmf = {
            enable = true;
            packages = [
              (pkgs.OVMF.override {
                secureBoot = true;
                tpmSupport = true;
              })
              .fd
            ];
          };
        };
      };

      ## Permissions
      # Add user to groups for permissions over
      # - network manipulation
      # - guest VM creation
      # - kernel virtualization
      users.groups = let
        users = cfg.users;
      in {
        libvirtd.members = users;
        qemu-libvirtd.members = users;
        kvm.members = users;
        netdev.members = users;
      };

      # Default to system over session.
      # This enables virtual network creation without root access.
      environment.sessionVariables.LIBVIRT_DEFAULT_URI = ["qemu:///system"];

      # Firewall settings for libvirt DHCP compatibility
      networking.firewall.checkReversePath = "loose";

      # Enable command line utility to create VM
      programs.virt-manager.enable = true;
    }
