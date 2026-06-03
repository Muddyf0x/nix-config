{ pkgs, lib, ... }: {

  # Lanzaboote — Secure Boot for NixOS using Unified Kernel Images (UKI)
  # Requires initial setup after first rebuild:
  #   1. sudo sbctl create-keys
  #   2. sudo nixos-rebuild switch
  #   3. sudo sbctl verify
  #   4. Reboot into UEFI, set Secure Boot to "Setup Mode"
  #   5. sudo sbctl enroll-keys --microsoft
  #   6. Enable Secure Boot in UEFI, reboot

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  # sbctl for managing secure boot keys
  environment.systemPackages = [ pkgs.sbctl ];

  # Persist secure boot keys across ephemeral root rollbacks
  # /var/lib is already on a persistent subvolume, so no extra config needed
}
