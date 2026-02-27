{ pkgs }:
{
  environment.systemPackages = with pkgs; [
    vim
    wget
  ];
  programs = {
    git = {
      enable = true;
      config = {
        user.name = "Muddyf0x";
        user.email = "dev.muddy@tuta.com";
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };
  };
}
