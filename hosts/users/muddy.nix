{ config, ... }:
{
  users.users.muddy = {
    isNormalUser = true;
    description = "muddy";
    extraGroups = [ "networkmanager" "wheel" "kvm" "libvirtd" ];
    hashedPasswordFile = config.sops.secrets.muddy-password.path;
  };
}
