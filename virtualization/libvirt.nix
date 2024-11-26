{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in
  with lib;
    mkIf cfg.virtualization.libvirt.enable {
      environment.systemPackages = with pkgs; [
        # libvirt things
        libvirt
        libvirt-glib
        unscd

        # A VM deployment tool
        colmena
        # Virshle from the flake
        # and dependencies
        # inputs.virshle.packages.${system}.default
        # Tool to easily create volumes(qcow)
        libguestfs
        guestfs-tools
      ];

      systemd.tmpfiles.rules = let
        cloud-hypervisor-fw = pkgs.fetchurl {
          url = "https://github.com/cloud-hypervisor/rust-hypervisor-firmware/releases/download/0.4.2/hypervisor-fw";
          sha256 = "0h0j0zc65pjnzrznmc3c3lrsyks6lgxh0k8j30zp41k6ph9ldhaq";
        };
        cloud-hypervisor-ovmf = pkgs.fetchurl {
          url = "https://github.com/cloud-hypervisor/edk2/releases/download/ch-6624aa331f/CLOUDHV.fd";
          sha256 = "0lh1ikngvf7lln3x9ng7c9nqb6ylv68yy0mvvlkhhk94l4c35j7x";
        };
      in [
        " L+ /run/cloud-hypervisor/hypervisor-fw - - - - ${cloud-hypervisor-fw}"
        " L+ /run/cloud-hypervisor/CLOUDVH.fd - - - - ${cloud-hypervisor-ovmf}"

        # Maddy directories
        # Make them by hand if maddy unit fails
        "d '/var/lib/virshle/vm' 774 root users - -"
        "Z '/var/lib/virshle/vm' 774 root users - -"

        "d '/var/lib/virshle/socket' 774 root users - -"
        "Z '/var/lib/virshle/socket' 774 root users - -"

        "d '/var/lib/virshle/net' 774 root users - -"
        "Z '/var/lib/virshle/net' 774 root users - -"

        "d '/var/lib/virshle/disk' 774 root users - -"
        "Z '/var/lib/virshle/disk' 774 root users - -"

        "d '/var/lib/virshle' 774 root users - -"
        "Z '/var/lib/virshle' 774 root users - -"
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

      system.nssDatabases = {
        hosts = [
          "libvirt"
          "libvirt_guest"
        ];
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
