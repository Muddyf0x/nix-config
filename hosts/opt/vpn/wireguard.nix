{ config, ... }:
{
  sops.secrets.wireguard-lappytop-a1 = {};

  networking.wg-quick.interfaces.a1 = {
    privateKeyFile = config.sops.secrets.wireguard-lappytop-a1.path;
    address = [ "10.0.0.2/32" ];
    dns = [ "10.0.0.1" ];
    peers = [
      {
        publicKey = "176bBc3OfivJ8hiWGL5o5/7x9jiWedLGjXqByDAdPWY=";
        allowedIPs = [
          "10.0.1.0/24"
          "10.0.50.0/24"
          "10.0.60.0/24"
          "10.0.10.0/24"
          "10.0.20.0/24"
          "10.0.0.1/32"
        ];
        endpoint = "80.120.159.218:51820";
        persistentKeepalive = 25;
      }
    ];
  };
}
