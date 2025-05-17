{ ... }:

{
  imports = [
    ./hardware.nix
    ./boot.nix
    ./packages.nix
    ./nvidia.nix
  ];

  system.stateVersion = "25.05";
}
