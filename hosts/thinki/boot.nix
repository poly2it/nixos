{ config, lib, pkgs, ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    enableCryptodisk = true;
  };
  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot";
  };
  boot.initrd.luks.devices = {
    cryptkey = {
      device = "/dev/disk/by-uuid/9c100edc-17fe-4340-a11a-75ae483a6737";
    };
    cryptroot = {
      device = "/dev/disk/by-uuid/38ee8c5a-5774-4637-8811-ab7bfef9a8a6";
      keyFile = "/dev/mapper/cryptkey";
      keyFileSize = 8192;
    };
    cryptswap = {
      device = "/dev/disk/by-uuid/8838e98a-4603-4137-bbff-53ebdb6b4ad0";
      keyFile = "/dev/mapper/cryptkey";
      keyFileSize = 8192;
    };
  };
  # boot.initrd.postDeviceCommands = lib.mkAfter ''
  #   cryptsetup close cryptkey
  # '';

 swapDevices = [{
    device = "/dev/mapper/cryptswap";
  }];

  networking.hostId = "71447199";

  system.stateVersion = "23.11";
}

