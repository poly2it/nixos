{ config, pkgs, lib, inputs, ... }: let
  inherit (pkgs.callPackage ../nixpak { inherit inputs; }) sandbox;
  zed-editor = (pkgs.symlinkJoin (let
    lspDeps = with pkgs; [
      nixd
      basedpyright
      gopls
      go
      vscode-langservers-extracted

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
        ${inputs.zed-editor.packages.${pkgs.system}.zed-editor-preview}/bin/zeditor $@
      '')
      inputs.zed-editor.packages.${pkgs.system}.zed-editor-preview
    ];
  }));
in {
  home.packages = [
    inputs.nvim.packages.${pkgs.system}.default
    zed-editor
  ] ++ (with pkgs; [
    gnome-calendar
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
    onlyoffice-bin
    zrythm
    qjackctl
    nurl
  ]) ++ (with sandbox; [
    gnome-music
    plattenalbum
    pipeline
    polari
    seahorse
  ]);

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
