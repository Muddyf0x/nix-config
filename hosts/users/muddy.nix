{ config, pkgs, ... }:
{
  users.users.muddy = {
    isNormalUser = true;
    description = "muddy";
    extraGroups = [ "networkmanager" "wheel" "kvm" "libvirtd" "plugdev" ];
    hashedPasswordFile = config.sops.secrets.muddy-password.path;
    shell = pkgs.zsh;
  };
}
