{ claude-code-nix, ... }:
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
    # Replaces nixpkgs' claude-code with the community package, which follows
    # upstream releases closely instead of the channel's slower cadence
    claude-code-nix.overlays.default
  ];
}
