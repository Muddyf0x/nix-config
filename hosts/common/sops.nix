{ pkgs, config, ...}:
{
  environment.systemPackages = with pkgs; [
    age
    sops
    ssh-to-age
  ];

  sops = {
    defaultSopsFile = ../../secrets.yaml;
    validateSopsFiles = false;

    age = {
      sshKeyPaths = [ "/etc/ssh/id_ed25519" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
    secrets = {
      muddy-password.neededForUsers = true;
    };
  };
}
