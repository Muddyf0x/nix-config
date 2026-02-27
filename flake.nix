
{
  description = "Muddy's Nixos-config flake";
# Based on quanchobi.io 's config

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
# Todo Add: 
# impermanence: clean up non permanent files on reboot
# nixvirt: Declerativ vm managment with libvirt
# stylix: styl everything in one place 
# silentSDDM: good looking login manager
# Disko: Declerativ partitioning and formationg 
  };

  outputs = { nixpkgs, home-manager, agenix, ... }: {
    nixosConfigurations = {
      # Desktop configuration
      desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./host/desktop.nix
          home-manager.nixosModules.home-manager
          agenix.nixosModules.default
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.anderson = import ./home/muddy;
          }
        ];
      };

      # Laptop configuration
      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./host/laptop.nix
          home-manager.nixosModules.home-manager
          agenix.nixosModules.default
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.anderson = import ./home/muddy;
          }
        ];
      };
    };
  };
}
