{ inputs, ... }:

{
  imports  = [
    ../home-modules/anyrun.nix
    ../home-modules/firefox.nix
    ../home-modules/fonts.nix
    ../home-modules/gnome-extensions.nix
    ../home-modules/gnome.nix
    ../home-modules/hidden-apps.nix
    ../home-modules/hyprland.nix
    ../home-modules/kitty.nix
    ../home-modules/packages.nix
    ../home-modules/shell.nix
    ../home-modules/silentium.nix
    ../home-modules/xdg.nix
    inputs.silentium.homeManagerModules.default
  ];

  home.stateVersion = "24.11";
}

