
{
  description = "Muddy's Nixos-config flake";
# Based on quanchobi.io 's config
# and EmergentMind's

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    # Manage home files and configs
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Manage secrets in a secure way 
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
# Todo Add: 
# impermanence: clean up non permanent files on reboot
# nixvirt: Declerativ vm managment with libvirt
# stylix: styl everything in one place 
# silentSDDM: good looking login manager
# Disko: Declerativ partitioning and formationg 
  };

  outputs = { nixpkgs, home-manager, sops-nix, ... }: {
    nixosConfigurations = {
      # Desktop configuration
      desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/desktop.nix
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
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
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.muddy = import ./home/muddy;
          }
        ];
      };
    };
  };
}
