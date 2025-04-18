{ inputs, ... }:

{
  imports  = [
    ../home-modules/shell.nix
    ../home-modules/gnome.nix
    ../home-modules/gnome-extensions.nix
    ../home-modules/fonts.nix
    ../home-modules/kitty.nix
    ../home-modules/firefox.nix
    ../home-modules/hidden-apps.nix
    ../home-modules/xdg.nix
    ../home-modules/packages.nix
    ../home-modules/hyprland.nix
    ../home-modules/anyrun.nix
    ../home-modules/silentium.nix
    inputs.silentium.homeManagerModules.default
  ];

  home.stateVersion = "24.11";

  home.shellAliases = {
    "colmena" = "NIXPKGS_ALLOW_UNFREE=1 colmena --experimental-flake-eval --impure";
    "nd" = "nix develop";
    "nf" = "nix fmt";
    "nc" = "nix flake check";
    "ex" = "exit";
  };
}

