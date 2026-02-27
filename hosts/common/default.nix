{
  imports = [
    ./local.nix
    ./fonts.nix
    ./networking.nix
    ./systemPkgs.nix
  ];
  nix.settings.experimental-features = ["nix-command" "flakes"];
}
