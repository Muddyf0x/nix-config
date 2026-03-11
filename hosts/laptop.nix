{ ... }: {
  imports = [
    ./common              # Packages used by all hosts
    # Users of the system
    ./users/muddy.nix 
    # hardware config
    ./hardware/laptop.nix 
    ./opt/bluetooth
    # host specific programs (i.e Desktop, gaming support, ... )
    ./opt/de/plasma6
    ./opt/gaming
    ./opt/torrent
    ./opt/libvirt
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
