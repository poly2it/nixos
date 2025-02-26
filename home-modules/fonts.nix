{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nerd-fonts.symbols-only
    noto-fonts-emoji
    iosevka
    cantarell-fonts
    noto-fonts
    noto-fonts-emoji
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-extra
  ];
}

