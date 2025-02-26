{ mkNixpakPackage, nixpakModules, pkgs }: let
  gcr_4 = pkgs.callPackage ./support/gcr_4.nix {};
in mkNixpakPackage {
  config = { sloth, ... }: {
    app.package = pkgs.seahorse.overrideAttrs (prev: {
      src = pkgs.fetchFromGitLab {
        domain = "gitlab.gnome.org";
        owner = "GNOME";
        repo = "seahorse";
        rev = "3df6cdc1f904d0a7269380946225c31a6ec3bd7c";
        hash = "sha256-uUqO4M1ir80+jtIzJnJYx5IU0W0kZP5cKyDkc32dt8M=";
      };
      postPatch = ''
        patchShebangs \
          build-aux/gpg_check.py
      '';
      nativeBuildInputs = prev.nativeBuildInputs ++ (with pkgs; [
        cmake
        python3
      ]);
      buildInputs = prev.buildInputs ++ (with pkgs; [
        gtk4
        libadwaita
        gcr_4
        qrencode
      ]);
    });
    imports = [
      nixpakModules.gui-base
      nixpakModules.network
    ];
    flatpak.appId = "org.gnome.Seahorse";
    dbus.policies = {
      "org.freedesktop.secrets" = "talk";
    };
    bubblewrap = {
      bind.rw = [
        (sloth.concat' sloth.homeDir "/.ssh")
        (sloth.concat' sloth.homeDir "/.gnupg")
      ];
    };
  };
}

