{
  description = "My personal NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme/beta";
      flake = false;
    };
    firefox-nightly.url = "github:nix-community/flake-firefox-nightly";
    flatpaks.url = "github:GermanBread/declarative-flatpak/latest";
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
    zed-editor.url = "github:HPsaucii/zed-editor-flake";
    # zed-editor.url = "github:HPsaucii/zed-editor-flake?rev=c4b6e1817d1d28efa068b70d71d54d0189626ca8";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    squads = {
      url = "github:IanTerzo/Squads";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    depot = {
      url = "git+ssh://forgejo@git.cenitly.com/cenitly/depot";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { nixpkgs, home-manager, flatpaks, rust-overlay, squads, ... }:
  let
    system = "x86_64-linux";
    pkgsFor = system: import ./packages (inputs // {inherit system;});
    pkgs = pkgsFor system;

    inherit (pkgs) lib;
    mkUser = username: { configuration, home ? "/home/${username}" }: {
      users.users.${username} = {
        home = home;
        group = "users";
        extraGroups = [ "adbusers" "audio" "kvm" "libvirtd" "podman" "systemd-journal" ];
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
        ./modules/certs.nix
        # ./modules/update.nix
        home-manager.nixosModules.home-manager
        flatpaks.nixosModules.default
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
    devShells.${system} = {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [
          go
        ];
      };
    };
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
    packages.${system} = {
      inherit
      (pkgs)
      dynamic-certs
      ;
    };
  };
}

