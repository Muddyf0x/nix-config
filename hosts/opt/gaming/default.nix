{
  programs = {
    steam = {
      enable = true;
    };
  };
  nixpkgs.config.allowUnfree = true;
  programs.nix-ld.enable = true;
}
