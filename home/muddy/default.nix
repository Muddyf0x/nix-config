{ inputs, config, pkgs, lib, ...}: 
{
  imports = [
#    ./cli
  ];
  config = {
    home = {
      username = "muddy"; 
      homeDirectory = lib.mkForce "/home/muddy";
      stateVersion = "25.11";
    };
    programs.home-manager.enable = true;
  };
}
