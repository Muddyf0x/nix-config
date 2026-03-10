{ ... }:
{
  users.users.muddy = {
    isNormalUser = true;
    description = "muddy";
    extraGroups = [ "networkmanager" "wheel" "kvm" "libvirtd" ];
  };
}
