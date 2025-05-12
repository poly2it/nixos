{ config, pkgs, inputs, ... }: let
  inherit (pkgs.callPackage ../nixpak { inherit inputs; }) sandbox;
in {
  home.packages = [
    inputs.nvim.packages.${pkgs.system}.default
    inputs.zed-editor.packages.${pkgs.system}.zed-editor
  ] ++ (with pkgs; [
    gnome-calendar
    papers
    totem
    baobab
    inkscape
    apostrophe
    fragments
    swaybg
    wormhole-rs
    onlyoffice-bin
  ]) ++ (with sandbox; [
    gnome-music
    plattenalbum
    pipeline
    polari
    seahorse
  ]);

  home.file.".var/app/com.valvesoftware.Steam/data/Steam/compatibilitytools.d/GE-Proton9-27.link" = let
    targetPath = "${config.home.homeDirectory}/.var/app/com.valvesoftware.Steam/data/Steam/compatibilitytools.d/GE-Proton9-27";
    linkPath = "${targetPath}.link";
  in {
    source = pkgs.fetchFromGitHub {
      owner = "GloriousEggroll";
      repo = "proton-ge-custom";
      rev = "f12a64ec30b37b01d3691ae56767f8a0e187fc56";
      hash = "sha256-9twtIXU80plSk0rXEV74Vad2/qpF+T8Z5LoPkL00EN4=";
    };
    onChange = ''
      rm -rf ${targetPath}
      cp --dereference -r ${linkPath} ${targetPath}
      chmod u+w -R ${targetPath}
    '';
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
      safe.directory = "${config.home.homeDirectory}/.config/nixos";
    };
  };

  services.mpd = {
    network.startWhenNeeded = true;
    enable = true;
  };
}

