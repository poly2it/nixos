{ mkNixpakPackage, nixpakModules, pkgs }:

mkNixpakPackage {
  config = { sloth, ... }: {
    app.package = pkgs.pipeline;
    imports = [
      nixpakModules.gui-base
    ];
    flatpak.appId = "de.schmidhuberj.tubefeeder";
    bubblewrap = {
      bind.rw = [
        (sloth.concat' sloth.runtimeDir "/mpd")
      ];
    };
  };
}

