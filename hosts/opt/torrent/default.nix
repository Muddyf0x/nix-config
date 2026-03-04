{pkgs, ...}:
{
  imports = [
    ../vpn
  ];  
  environment.systemPackages = [
    pkgs.qbittorrent
  ];
}
