{ pkgs, ... }:

{
  nixpkgs.overlays = [
  ];

  environment.systemPackages = with pkgs; [
    gvfs

    wget
    git

    neovim
    vim
    wl-clipboard

    xdg-terminal-exec-mkhl

    glxinfo

    morewaita-icon-theme
    nautilus
    mission-center
    metadata-cleaner
    celluloid
    eyedropper
  ];

  programs.git.config.init.defaultBranch = "master";

  services.gvfs.enable = true;
  services.flatpak.enable = true;
  services.flatpak.remotes = {
    "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    "flathub-beta" = "https://dl.flathub.org/beta-repo/flathub-beta.flatpakrepo";
  };

  services.journald.storage = "persistent";

  programs.hyprland.enable = true;
}

