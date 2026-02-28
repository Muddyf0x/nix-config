{ inputs, config, pkgs, ...}: 
{
  imports = [
#    ./cli
  ];
  config = {
    home = {
      username = "muddy"; 
      homeDirectory = "/home/muddy";
      stateVersion = "25.11";
    };
    programs.home-manager.enable = true;
  };
}
