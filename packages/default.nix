{
  nixpkgs,
  system,
  rust-overlay,
  squads,
  ...
}: let
  pkgs = (import nixpkgs) {
    inherit system config;
    overlays = [
    ];
  };
  inherit (pkgs) lib;
  allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
        "cuda-merged"
        "cudatoolkit"
        "nvidia-x11"
        "nvidia-settings"
        "nvidia-persistenced"
        "modrinth-app"
        "modrinth-app-unwrapped"
      ];
  config = {
    inherit allowUnfreePredicate;
  };
in
  (import nixpkgs) {
    inherit system;
    overlays = [
      (import rust-overlay)
      (import squads)
      (
        self: _: {
          dynamic-certs = self.callPackage ./dynamic-certs {};
        }
      )
    ];
    inherit config;
  }
