{ config, pkgs, ... }:
{
  users.users.muddy = {
    isNormalUser = true;
    description = "jonas";
    extraGroups = [ "networkmanager" "wheel" "kvm" "libvirtd" ];
    hashedPasswordFile = config.sops.secrets.jonas-password.path;
    shell = pkgs.zsh;
  };
}
