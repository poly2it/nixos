{ mkNixpakPackage, nixpakModules, pkgs }: let
  telepathy-logger = pkgs.callPackage ./support/telepathy-logger.nix {};
in mkNixpakPackage {
  config = { sloth, ... }: {
    app.package = pkgs.polari;
    imports = [
      nixpakModules.gui-base
      nixpakModules.network
    ];
    flatpak.appId = "org.gnome.Polari";
    dbus.policies = {
      "org.freedesktop.Telepathy.Client.Polari" = "own";
      "org.freedesktop.Telepathy.Client.Polari.*" = "own";
      "org.freedesktop.Telepathy.Client.GnomeShell.*" = "talk";
      "org.freedesktop.Telepathy.Client.TpGLibRequestAndHandle.*" = "own";
      "org.freedesktop.Telepathy.AccountManager" = "own";
      "org.freedesktop.Telepathy.ChannelDispatcher" = "own";
      "org.freedesktop.Telepathy.MissionControl5" = "own";
      "org.freedesktop.Telepathy.ConnectionManager.idle" = "own";
      "org.freedesktop.Telepathy.Connection.idle.irc.*" = "own";
      "org.freedesktop.Telepathy.Client.Logger" = "own";
      "org.freedesktop.Telepathy" = "own";
      "org.freedesktop.secrets" = "talk";
    };
    bubblewrap = {
      env = {
        NO_AT_BRIDGE = "1";
      };
      bind.ro = [
        [
          "${pkgs.telepathy-mission-control.lib}/libexec/mission-control-5"
          "/app/libexec/mission-control-5"
        ]
        [
          "${pkgs.telepathy-idle}/libexec/telepathy-idle"
          "/app/libexec/telepathy-idle"
        ]
        [
          "${telepathy-logger}/libexec/telepathy-idle"
          "/app/libexec/telepathy-idle"
        ]
      ];
      bind.rw = [
        (sloth.concat' sloth.xdgDataHome "/TpLogger")
        (sloth.concat' sloth.xdgConfigHome "/polari")
        (sloth.concat' sloth.xdgDataHome "/polari")
        (sloth.concat' sloth.xdgCacheHome "/polari")
        (sloth.concat' sloth.xdgStateHome "/polari")
      ];
    };
  };
}

