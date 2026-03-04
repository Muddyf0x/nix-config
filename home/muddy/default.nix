{ config, pkgs, lib, ...}: 
{
  imports = [
    ./linkedConfigs
    ./nixConfigs
  ];
    home = {
      username = "muddy"; 
      homeDirectory = lib.mkForce "/home/muddy";
      stateVersion = "25.11";
    };
    home.packages = with pkgs; [
      alacritty
      neovim
      ripgrep
      nil
      nixpkgs-fmt
      nodejs
      gcc
      fastfetch
      anki
      age
      onlyoffice-desktopeditors
      mpv
    ];
    programs.home-manager.enable = true;
}
