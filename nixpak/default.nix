{ inputs, pkgs, lib, ... }: let
  inherit (inputs) nixpak;
  mkNixpakPackage = args: let
    mkNixPak = nixpak.lib.nixpak {
      inherit (pkgs) lib;
      inherit pkgs;
    };
    pkg = mkNixPak args;
  in pkg.config.env;
  nixpakModules = {
    gui-base = ./modules/gui-base.nix;
    network = ./modules/network.nix;
  };
in {
  sandbox = ({
    gnome-music = ./gnome-music.nix;
    pipeline = ./pipeline.nix;
    plattenalbum = ./plattenalbum.nix;
    polari = ./polari.nix;
    seahorse = ./seahorse.nix;
  }
  |> lib.mapAttrs (name: value: (pkgs.callPackage value { inherit mkNixpakPackage nixpakModules; })))
  // inputs.nixpak-pkgs.packages.${pkgs.system};
}

