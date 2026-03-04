{ ... }: {
  imports = [
    ./common
    ./users/muddy.nix
    ./hardware/laptop.nix
    ./opt/de/plasma6
    ./opt/gaming
    ./opt/bluetooth
    ./opt/torrent
#    currently broken with sddm
#    ./opt/fingerprint    
  ];
  # Unique to Host
  networking.hostName = "lappytop";
  system.stateVersion = "25.11";

  # TODO unifi bootloader config -> 
  # combine with switching to btrfs with impermanance 
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
}
