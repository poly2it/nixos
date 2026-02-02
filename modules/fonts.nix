{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    (mona-sans.overrideAttrs (self: super: rec {
      version = "2.0.8";
      src = fetchFromGitHub {
        tag = version;
        owner = "github";
        repo = "mona-sans";
        sha256 = "sha256-L1KlduItf1jBrw08NwbJvZFemLY8JHRXq2UDl9Wlq70=";
      };
  installPhase = ''
    install -D -m444 -t $out/share/fonts/opentype fonts/static/otf/*.otf
    install -D -m444 -t $out/share/fonts/truetype fonts/static/ttf/*.ttf fonts/variable/*.ttf
  '';

    }))
  ];

  fonts.fontconfig = {
    enable = true;
    subpixel.rgba = "rgb";
    hinting.enable = false;
  };
}
