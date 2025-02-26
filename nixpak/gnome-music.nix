{ mkNixpakPackage, nixpakModules, pkgs }:

mkNixpakPackage {
  config = { sloth, ... }: {
    app.package = pkgs.gnome-music;
    imports = [
      nixpakModules.gui-base
    ];
    dbus.policies = {
      "org.freedesktop.Tracker3.Miner.Files" = "talk";
    };
    flatpak.appId = "org.gnome.Music";
    bubblewrap = {
      network = true;
      bind.ro = [
        sloth.xdgMusicDir
      ];
      env = {
        XDG_MUSIC_DIR = sloth.xdgMusicDir;
      };
    };
  };
}

