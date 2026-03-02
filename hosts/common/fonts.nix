{pkgs, ...}: 
{
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts-cjk-sans # needed for japanese chars
  ];
}
