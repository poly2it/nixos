{ mkNixpakPackage, nixpakModules, pkgs }:

mkNixpakPackage {
  config = { sloth, ... }: {
    app.package = pkgs.heroic;
    imports = [
      nixpakModules.gui-base
      nixpakModules.network
    ];
    flatpak.appId = "com.heroicgameslauncher.Heroic";
    bubblewrap = {
      bind.ro = [
        (sloth.concat ["/run/opengl-driver/lib/gbm/"])
      ];
      bind.rw = [
        (sloth.concat' sloth.xdgDataHome "/lutris")
        (sloth.concat' sloth.xdgDataHome "/steam")
        (sloth.concat' sloth.xdgDataHome "/applications")
        (sloth.concat' sloth.homeDir "/.var/app/com.valvesoftware.Steam")
        (sloth.concat' sloth.xdgDataHome "/umu")
        (sloth.concat' sloth.xdgConfigHome "/heroic")
      ];
    };
  };
}

