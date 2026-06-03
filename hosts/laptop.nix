{ pkgs, ... }: {
  imports = [
    ./common              # Packages used by all hosts
    # Users of the system
    ./users/muddy.nix 
    # hardware config
    ./hardware/laptop.nix
    # declarative disk layout (btrfs + FDE)
    ./disko/laptop.nix
    ./opt/bluetooth
    # host specific programs (i.e Desktop, gaming support, ... )
    ./opt/de/plasma6
    ./opt/gaming
    ./opt/torrent
    ./opt/libvirt
    ./opt/lanzaboote
#    currently broken with sddm
#    ./opt/fingerprint
  ];
  # Unique to Host
  networking.hostName = "lappytop";
  system.stateVersion = "25.11";
  environment.systemPackages = [
    pkgs.ntfs3g
  ];
}
