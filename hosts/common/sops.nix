{ pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    age
    sops-nix
    ssh-age
  ];  
}
