{ mkNixpakPackage, nixpakModules, pkgs }:
mkNixpakPackage {
  config = { sloth, ... }: {
    app.package = pkgs.rocketchat-desktop;
    imports = [
      nixpakModules.gui-base
      nixpakModules.network
    ];
    flatpak.appId = "org.gnome.Polari";
    dbus.policies = {
      "org.freedesktop.Notifications" = "talk";
      "org.gnome.Mutter.IdleMonitor" = "talk";
      "org.kde.StatusNotifierWatcher" = "talk";
      "com.canonical.AppMenu.Registrar" = "talk";
      "com.canonical.indicator.application" = "talk";
      "org.ayatana.indicator.application" = "talk";
    };
    bubblewrap = {
      bind.ro = [
        [
          # "${pkgs.telepathy-mission-control.lib}/libexec/mission-control-5"
          # "/app/libexec/mission-control-5"
        ]
      ];
      bind.rw = [
        # (sloth.concat' sloth.xdgDataHome "/TpLogger")
        # (sloth.concat' sloth.xdgConfigHome "/polari")
        # (sloth.concat' sloth.xdgDataHome "/polari")
        # (sloth.concat' sloth.xdgCacheHome "/polari")
        # (sloth.concat' sloth.xdgStateHome "/polari")
      ];
    };
  };
}

