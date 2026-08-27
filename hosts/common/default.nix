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

  nixpkgs.overlays = [
    (final: prev: {
      cisco-packet-tracer_9 = final.callPackage ./cisco-packet-tracer.nix { };
    })
  ];
}
