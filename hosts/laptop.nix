{ config, pkgs, ... }: {
  imports = [
    ./common    
  ];

  networking.hostName = "lappytop";
}
