{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in {
  environment.systemPackages = with pkgs; [
    docker
    # libvirt things
    OVMF
    # Build images based on flakes and local config
    nixos-generators
    # A VM deployment tool
    colmena
    # Virshle from the flake
    # and dependencies
    inputs.virshle.packages.${system}.default
    deno
  ];

  # Enable docker usage
  virtualisation.docker.enable = true;

  # Enable libvirt virtualization framework
  virtualisation.libvirtd = {
    enable = true;
    # A name server to map VM ip to its name defined with libvirt
    # Allows this: `ssh nixos_vm`
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
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        packages = [pkgs.OVMF];
        enable = true;
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
    docker.members = users;
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

  # Expose guest VM tty to host through virsh
  # boot.kernelParams = [
  #   "console=tty1"
  #   "console=ttyS0,115200"
  # ];
}
