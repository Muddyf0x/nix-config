{ pkgs, ... }:
{
  programs = {
    git = {
      enable = true;
    };

    obs-studio = {
      enable = true;
      plugins = [ pkgs.obs-studio-plugins.obs-pipewire-audio-capture ]; # per-app audio capture
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        ll = "ls -la";
      };

      history = {
        size = 10000;
        path = "$HOME/.zsh_history";
      };

      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "sudo" ];
        theme = "robbyrussell";
      };
    };
  };
}
