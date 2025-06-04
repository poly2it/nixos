{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    mullvad
    mullvad-vpn

    android-udev-rules

    (symlinkJoin {
      name = "signal-desktop";
      paths = [ signal-desktop ];
      nativeBuildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram "$out/bin/signal-desktop" \
          --add-flags '--password-store="gnome-libsecret"'
      '';
    })

    thunderbird-latest
  ];

  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  services.flatpak.packages = [
    "flathub:app/dev.bragefuglseth.Keypunch//stable"
    "flathub:app/io.gitlab.news_flash.NewsFlash//stable"
    "flathub:app/com.valvesoftware.Steam//stable"
    "flathub:app/com.usebottles.bottles//stable"
    "flathub:app/io.github.nokse22.Exhibit//stable"
    "flathub:app/com.heroicgameslauncher.hgl//stable"
    "flathub:app/com.modrinth.ModrinthApp//stable"
    "flathub:app/com.github.tchx84.Flatseal//stable"
  ];

  services.syncthing = {
    enable = true;
    user = "bach";
    dataDir = "/home/bach/sync";
    configDir = "/home/bach/.config/syncthing";
  };

  programs.adb.enable = true;
}

