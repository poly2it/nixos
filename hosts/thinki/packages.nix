{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    mullvad
    mullvad-vpn
  ];

  services.flatpak.packages = [
  ];

  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  programs.git.config = {
    safe.directory = [
      "/home/holst/.config/nixos"
    ];
  };

  # services.syncthing = {
  #   enable = true;
  #   user = "bach";
  #   dataDir = "/home/holst/sync";
  #   configDir = "/home/holst/.config/syncthing";
  # };
}

