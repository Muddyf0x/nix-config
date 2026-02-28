{ config, pkgs, ... }: {
  imports = [
    ./common
    ./opt/de/plasma6
    ./opt/gaming
    ./opt/bluetooth
    ./hardware/laptop.nix
    ./users/muddy.nix
  ];
  # Unique to Host
  networking.hostName = "lappytop";

  # TODO unifi bootloader config -> 
  # combine with switching to btrfs with impermanance 
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
}
