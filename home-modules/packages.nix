{ config, pkgs, lib, inputs, ... }: let
  inherit (pkgs.callPackage ../nixpak { inherit inputs; }) sandbox;
  zed-editor = (pkgs.symlinkJoin (let
    lspDeps = with pkgs; [
      nixd
      basedpyright
      gopls
      go
      vscode-langservers-extracted
      nodejs_24

      # Rust
      (rust-bin.selectLatestNightlyWith (t: t.default.override {
        targets = [ "x86_64-unknown-linux-gnu" "wasm32-unknown-unknown" ];
        extensions = [ "rustc-codegen-cranelift-preview" "rust-analyzer" ];
      }))
      pkg-config
      openssl
      mold
      clang
      llvmPackages.lld
      wasm-bindgen-cli

      ocamlPackages.ocaml-lsp

      # Python
      (pkgs.python3.withPackages (p: with p; [
        httpx
      ]))
    ];
  in {
    name = "zed-editor";
    paths = [
      (pkgs.writeShellScriptBin "zeditor" ''
        export PATH=$SHELL:${lib.makeBinPath lspDeps}:$PATH
        ${pkgs.zed-editor}/bin/zeditor $@
      '')
      # inputs.zed-editor.packages.${pkgs.system}.zed-editor-preview-bin
      pkgs.zed-editor
    ];
  }));
in {
  home.packages = [
    inputs.nvim.packages.${pkgs.system}.default
    inputs.depot.packages.${pkgs.system}.sandbox.figma-linux
    zed-editor
  ] ++ (with pkgs; [
    gnome-calendar
(figma-agent.overrideAttrs (self: super: {
  src = fetchFromGitHub {
    owner = "neetly";
    repo = "figma-agent-linux";
    rev = "274d2c098a8809d1bedc2ce815d2c3ca9d412361";
    sha256 = "sha256-Maa5uSENWrkhgP+mcYToNxzDSMz82Sp8g1mXw9Y/Mx4=";
  };
  version = "0.4.3";

  cargoHash = "sha256-xDmzq1PuuGp00wUCPzqYLQ5LWNeanRf8vhqvfCjYPLc=";
  cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
    inherit (self) src;
    name = "${self.pname}-${self.version}";
    hash = self.cargoHash;
    patches = self.cargoPatches or [];
  };
}))
      papers
    totem
    baobab
    inkscape
    apostrophe
    fragments
    swaybg
    wormhole-rs
    bat
    htop
    silver-searcher
    onlyoffice-desktopeditors
    # zrythm
    qjackctl
    nurl
    ungoogled-chromium
    squads
    zeroad
    dig
    virt-manager
    virt-viewer
  ]) ++ (with sandbox; [
    gnome-music
    plattenalbum
    pipeline
    polari
    seahorse
  ]);

  xdg.desktopEntries.figma-linux = {
    name = "Figma";
    comment = "Figma desktop application for Linux";
    exec = "figma-linux %U";
    icon = "figma-linux";
    terminal = false;
    type = "Application";
    mimeType = [ "x-scheme-handler/figma" ];
  };

  services.swayosd = {
    enable = true;
  };

  home.file.".var/app/com.valvesoftware.Steam/data/Steam/compatibilitytools.d/GE-Proton9-27.link" = let
    targetPath = "${config.home.homeDirectory}/.var/app/com.valvesoftware.Steam/data/Steam/compatibilitytools.d/GE-Proton9-27";
    linkPath = "${targetPath}.link";
  in {
    source = pkgs.fetchFromGitHub {
      owner = "GloriousEggroll";
      repo = "proton-ge-custom";
      rev = "f12a64ec30b37b01d3691ae56767f8a0e187fc56";
      hash = "sha256-9twtIXU80plSk0rXEV74Vad2/qpF+T8Z5LoPkL00EN4=";
    };
    onChange = ''
      rm -rf ${targetPath}
      cp --dereference -r ${linkPath} ${targetPath}
      chmod u+w -R ${targetPath}
    '';
  };

  programs.git = {
    enable = true;
    aliases = {
      "uncommit" = "reset --soft HEAD^";
      "unadd" = "restore --staged";
      "new-branch-with-local-changes" = "checkout -b";
    };
    extraConfig = {
      init.defaultBranch = "master";
      user.name = "poly2it";
      user.email = "84731064+poly2it@users.noreply.github.com";
      safe.directory = "${config.home.homeDirectory}/.config/nixos";
      push.autoSetupRemote = true;
    };
  };

  services.mpd = {
    network.startWhenNeeded = true;
    enable = true;
  };
}
