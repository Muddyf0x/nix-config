{ config, pkgs, lib, ...}: 
{
  # Import configurations
  imports = [
    ./linkedConfigs # Program specific configurations
    ./nixConfigs    # Programs configured in/with Nix
  ];
    # User/Home Configuration
    home = {
      username = "muddy";
      homeDirectory = lib.mkForce "/home/muddy";
      stateVersion = "25.11";
      sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
    };
    
    # Install Pkgs sorted by way of configuration
    home.packages = with pkgs; [
      # Linked Configs
      alacritty
      neovim
      # Nix Configs

      # Unconfigured Programs
      age
      android-tools
      anki
      brave
      cisco-packet-tracer_9
      claude-code
      easyeffects
      fastfetch
      libreoffice
      mpv
      nil
      nodejs
      nixpkgs-fmt
      thunderbird
      obsidian
      kdePackages.kdenlive
      learnharness
      onlyoffice-desktopeditors
      ripgrep
      gcc

      # Arduino
      arduino-ide
      python3 # ESP32 core runs gen_esp32part.py / flasher.py with python3

      # LaTeX
      vscodium
      texlive.combined.scheme-full
      zathura
    ];
    # Let Home-manager manage itself
    programs.home-manager.enable = true;
}
