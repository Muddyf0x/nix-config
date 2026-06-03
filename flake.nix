
{
  description = "Muddy's Nixos-config flake";
# Based on quanchobi.io 's config
# and EmergentMind's

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";
    # Manage home files and configs
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Manage secrets in a secure way
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Declarative disk partitioning and formatting
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Ephemeral root — persist only what's declared
    impermanence.url = "github:nix-community/impermanence";
# Secure Boot for NixOS using UKI (Unified Kernel Images)
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
# Todo Add:
# nixvirt: Declerativ vm managment with libvirt
# stylix: styl everything in one place
# silentSDDM: good looking login manager
  };

  outputs = { nixpkgs, home-manager, sops-nix, disko, impermanence, lanzaboote, ... }: {
    nixosConfigurations = {
      # Desktop configuration
      desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/desktop.nix
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          disko.nixosModules.disko
          impermanence.nixosModules.impermanence
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.muddy = import ./home/muddy;
          }
        ];
      };

      # Laptop configuration
      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/laptop.nix
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          disko.nixosModules.disko
          impermanence.nixosModules.impermanence
          lanzaboote.nixosModules.lanzaboote
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.muddy = import ./home/muddy;
          }
        ];
      };

      # VM test target — identical to laptop but targets /dev/vda (virtio disk)
      laptop-vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/laptop.nix
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          disko.nixosModules.disko
          impermanence.nixosModules.impermanence
          lanzaboote.nixosModules.lanzaboote
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.muddy = import ./home/jonas;
            disko.devices.disk.nvme0n1.device = nixpkgs.lib.mkForce "/dev/vda";
            boot.initrd.availableKernelModules = [ "virtio_pci" "virtio_blk" ];
          }
        ];
      };
    };
  };
}
