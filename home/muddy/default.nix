{ config, pkgs, lib, ...}: 
{
  # Import configurations
  imports = [
    ./linkedConfigs # Program specific configurations
    ./nixConfigs    # Programs configured in/with Nix
  ];
    # User/Home Configuration
    home = {
      username = "muddy"; 
      homeDirectory = lib.mkForce "/home/muddy";
      stateVersion = "25.11";
    };
    
    # Install Pkgs sorted by way of configuration
    home.packages = with pkgs; [
      # Linked Configs
      alacritty
      neovim
      # Nix Configs

      # Unconfigured Programs
      age
      anki
      fastfetch
      mpv
      nil
      nodejs
      nixpkgs-fmt
      obsidian
      onlyoffice-desktopeditors
      ripgrep
      gcc
    ];
    # Let Home-manager manage itself
    programs.home-manager.enable = true;
}
