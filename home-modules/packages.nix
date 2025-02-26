{ pkgs, inputs, ... }: let
  inherit (pkgs.callPackage ../nixpak { inherit inputs; }) sandbox;
in {
  home.packages = [
    inputs.nvim.packages.x86_64-linux.default
  ] ++ (with pkgs; [
    gnome-calendar
    papers
    totem
    inkscape
    apostrophe
    fragments
    swaybg
  ]) ++ (with sandbox; [
    gnome-music
    plattenalbum
    pipeline
    polari
    seahorse
  ]);

  home.file.".var/app/com.valvesoftware.Steam/data/Steam/compatibilitytools.d/GE-Proton9-16".source = builtins.fetchTarball {
    url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton9-16/GE-Proton9-16.tar.gz";
    sha256 = "sha256:1x0l0q9wvz7y65315c6mb388mjsvsm7340cgqbdc3vrbn3jm9ylz";
  };

  programs.git = {
    enable = true;
    aliases = {
      "uncommit" = "reset --soft HEAD^";
      "unadd" = "restore --staged";
    };
    extraConfig = {
      init.defaultBranch = "master";
      user.name = "poly2it";
      user.email = "84731064+poly2it@users.noreply.github.com";
    };
  };

  services.mpd = {
    network.startWhenNeeded = true;
    enable = true;
  };
}

