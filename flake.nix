{
  description = "My personal NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme/beta";
      flake = false;
    };
    firefox-nightly.url = "github:nix-community/flake-firefox-nightly";
    flatpaks.url = "github:GermanBread/declarative-flatpak/stable-v3";
    anyrun = {
      url = "github:anyrun-org/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpak-pkgs = {
      url = "github:nixpak/pkgs";
      inputs.nixpak.follows = "nixpak";
    };
    nvim = {
      url = "github:poly2it/nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    silentium = {
      url = "github:poly2it/silentium";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.firefox-gnome-theme.follows = "firefox-gnome-theme";
    };
    zed-editor.url = "github:poly2it/zed-editor-flake/zed-beta";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { nixpkgs, home-manager, flatpaks, rust-overlay, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        (import rust-overlay)
      ];
      config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "cuda-merged"
        "cudatoolkit"
        "nvidia-x11"
        "nvidia-settings"
        "nvidia-persistenced"
        "modrinth-app"
        "modrinth-app-unwrapped"
      ];
    };

    inherit (pkgs) lib;
    mkUser = username: { configuration, home ? "/home/${username}" }: {
      users.users.${username} = {
        home = home;
        group = "users";
        extraGroups = [ "adbusers" "audio" "kvm" "systemd-journal" ];
        isNormalUser = true;
        initialPassword = "nixos";
      };

      home-manager.users.${username} = configuration;
    };
    mkHost = hostname: { modules }: inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      inherit pkgs;
      modules = [
        ./modules/nix.nix
        ./modules/locale.nix
        ./modules/graphics.nix
        ./modules/sound.nix
        ./modules/gnome.nix
        ./modules/fonts.nix
        ./modules/network.nix
        ./modules/packages.nix
        ./modules/vm.nix
        ./modules/printing.nix
        ./modules/security.nix
        ./modules/update.nix
        inputs.chaotic.nixosModules.default
        home-manager.nixosModules.home-manager
        flatpaks.nixosModules.declarative-flatpak
        {
          networking.hostName = hostname;
          users.users.gdm = { extraGroups = [ "video" ]; };
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs; };
            backupFileExtension = "shadowed";
          };
        }
      ] ++ modules;
    };
  in
  {
    nixosConfigurations = {
      fractal = mkHost "fractal" {
        modules = [
          ./hosts/fractal
          (mkUser "bach" { configuration = import ./users/bach.nix; })
        ];
      };
      lenoving = mkHost "lenoving" {
        modules = [
          ./hosts/lenoving
          (mkUser "bach" { configuration = import ./users/bach.nix; })
        ];
      };
      thinki = mkHost "thinki" {
        modules = [
          ./hosts/thinki
          (mkUser "holst" { configuration = import ./users/holst.nix; })
        ];
      };
    };
  };
}

