{ pkgs, config, ...}:
{
  environment.systemPackages = with pkgs; [
    age
    sops
    ssh-to-age
  ];

  # Write the host key directly into /persist so the openssh activation script
  # never touches the ephemeral root. sops-nix reads from the same path,
  # bypassing any dependency on the impermanence bind-mount timing.
  services.openssh = {
    enable = true;
    openFirewall = false;
    hostKeys = [{
      path = "/persist/etc/ssh/id_ed25519";
      type = "ed25519";
    }];
  };

  sops = {
    defaultSopsFile = ../../secrets.yaml;
    validateSopsFiles = false;

    age = {
      sshKeyPaths = [ "/persist/etc/ssh/id_ed25519" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
    secrets = {
      muddy-password.neededForUsers = true;
    };
  };
}
