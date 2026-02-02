{
  pkgs,
  lib,
  config,
  ...
}: let
  mona-sans = pkgs.mona-sans.overrideAttrs (self: super: rec {
    version = "2.0.8";
    src = pkgs.fetchFromGitHub {
      tag = version;
      owner = "github";
      repo = "mona-sans";
      sha256 = "sha256-L1KlduItf1jBrw08NwbJvZFemLY8JHRXq2UDl9Wlq70=";
    };
    installPhase = ''
      install -D -m444 -t $out/share/fonts/opentype fonts/static/otf/*.otf
      install -D -m444 -t $out/share/fonts/truetype fonts/static/ttf/*.ttf fonts/variable/*.ttf
    '';
  });
  fonts = with pkgs; [
    cantarell-fonts
    ibm-plex
    iosevka
    liberation-sans-narrow
    liberation_ttf
    mona-sans
    nerd-fonts.symbols-only
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    (google-fonts.override {
      fonts = [
        "Arimo"
        "DM Sans"
        "Domine"
        "Familjen Grotesk"
        "Inria Serif"
        "Instrument Sans"
        "Instrument Serif"
        "Inter"
        "Michroma"
        "Onest"
        "Source Serif 4"
        "Special Gothic Expanded One"
      ];
    })
  ];
in {
  home.packages = fonts;
  # This is a quirk to work around ONLYOFFICE not registering fonts in all locations.
  home.file =
    fonts
    |> lib.map (
      pkg: let
        name = "${config.xdg.userDirs.extraConfig.XDG_DATA_HOME}/fonts/${pkg.name}";
        source = pkg;
      in {
        inherit name;
        value = {
          inherit source;
          onChange = ''
            rm -rf ${name}
            cp --dereference -r ${source} ${name}
            chmod u+w -R ${name}
          '';
        };
      }
    )
    |> lib.listToAttrs;
}
