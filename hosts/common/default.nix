{
  imports = [
    ./local.nix
    ./fonts.nix
    ./networking.nix
    ./systemPkgs.nix
    ./sops.nix
    ./impermanence.nix
  ];
  nix.settings.experimental-features = ["nix-command" "flakes"];
}
