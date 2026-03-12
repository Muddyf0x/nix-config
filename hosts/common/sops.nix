{ pkgs, inputs, config, ...}:
{
  environment.systemPackages = with pkgs; [
    age
    sops
    ssh-to-age
  ];  
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = "../../secrets.yaml";
    validateSopsFiles = false;

    age = {
      sshKeyPaths = [ "/etc/ssh/id_ed25519" ];
      keyFile = "var/lib/sops-nix/key.txt";
      generateKey = true;
    };
    secrets = {
    
    };
  };
}
