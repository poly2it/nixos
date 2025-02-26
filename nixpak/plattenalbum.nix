{ mkNixpakPackage, nixpakModules, pkgs }:

mkNixpakPackage {
  config = { sloth, ... }: {
    app.package = pkgs.plattenalbum;
    imports = [
      nixpakModules.gui-base
    ];
    flatpak.appId = "de.wagnermartin.Plattenalbum";
    bubblewrap = {
      bind.ro = [
        sloth.xdgMusicDir
      ];
      bind.rw = [
        (sloth.concat' sloth.runtimeDir "/mpd")
      ];
    };
  };
}

