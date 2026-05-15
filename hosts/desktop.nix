{ pkgs, ... }: {
  imports = [
    ./common              # Packages used by all hosts
    # Users of the system
    ./users/muddy.nix
    # hardware config
    ./hardware/desktop.nix
    # declarative disk layout (btrfs + FDE)
    ./disko/desktop.nix
    ./opt/bluetooth
    # host specific programs (i.e Desktop, gaming support, ... )
    ./opt/de/plasma6
    ./opt/gaming
    ./opt/torrent
    ./opt/libvirt
  ];
  # Unique to Host
  networking.hostName = "desktop";
  system.stateVersion = "25.11";

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  environment.systemPackages = [
    pkgs.ntfs3g
  ];
}
