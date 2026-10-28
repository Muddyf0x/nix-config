{ pkgs, ... }:
{
  programs = {
    steam = {
      enable = true;
    };
  };
  # Minecraft (official launcher isn't packaged in nixpkgs)
  environment.systemPackages = [ pkgs.prismlauncher ];
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
