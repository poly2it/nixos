{ inputs, lib, ... }:

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
  ];

  home.stateVersion = "24.11";

  home.shellAliases = {
    v = lib.mkForce "${inputs.nvim.packages.x86_64-linux.default}/bin/nvim";
  };
}

