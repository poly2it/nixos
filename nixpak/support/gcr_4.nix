{ pkgs, lib }:

pkgs.gcr_4.overrideAttrs (prev: rec {
  version = "4.3.91";
  src = pkgs.fetchurl {
    url = "mirror://gnome/sources/gcr/${lib.versions.majorMinor version}/gcr-${version}.tar.xz";
    hash = "sha256-nTJu09eK0Or7CEg5WgaK2+/ets/wTsVhXLPvdn2TOZA=";
  };
})

