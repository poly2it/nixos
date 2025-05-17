{ pkgs, config, ... }:
let
  home = config.home.homeDirectory;
in
{
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];

    config.common.default = "gnome";
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    documents = "${home}/documents";
    download = "${home}/downloads";
    music = "${home}/music";
    pictures = "${home}/pictures";
    videos = "${home}/videos";
    desktop = null;
    publicShare = null;
    templates = null;
    extraConfig = {
      "XDG_PROJECTS_DIR" = "${home}/projects";
      "XDG_REPOS_DIR" = "${home}/repos";
      "XDG_CONFIG_HOME" = "${home}/.config";
      "XDG_CACHE_HOME" = "${home}/.local/cache";
      "XDG_DATA_HOME" = "${home}/.local/share";
      "XDG_STATE_HOME" = "${home}/.local/state";
    };
  };

  xdg.dataFile."mime/packages/application-extension-ply.xml".text = ''
    <?xml version="1.0" encoding="utf-8"?>
    <mime-info xmlns='http://www.freedesktop.org/standards/shared-mime-info'>
      <mime-type type="application/extension-ply">
        <comment>PLY file</comment>
        <glob pattern="*.ply"/>
      </mime-type>
    </mime-info>
  '';

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/extension-ply" = "io.github.nokse22.Exhibit.desktop";
      "application/json" = "org.gnome.TextEditor.desktop";
      "application/pdf" = "org.gnome.Papers.desktop";
      "text/plain" = "org.gnome.TextEditor.desktop";
      "text/x-chdr" = "org.gnome.TextEditor.desktop";
      "image/x-adobe-dng" = "org.gnome.Loupe.desktop";
      "message/rfc822" = "org.gnome.TextEditor.desktop";
    };
  };

  home.file."pictures/wallpapers".source = ../wallpapers;
}

