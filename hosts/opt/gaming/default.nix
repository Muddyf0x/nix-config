{ pkgs, ... }:
{
  programs = {
    steam = {
      enable = true;
    };
  };
  nixpkgs.config.allowUnfree = true;
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      libxrandr
      libx11
      gtk3
      glib
    ];
  };

}
