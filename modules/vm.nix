{ pkgs, ... }:

let virtualisation = {
  memorySize = 8192;
  cores = 8;
  qemu.options = [
    "-accel kvm"
    "-audio pa"
  ];
};
in
{
  virtualisation.vmVariant = {
    inherit virtualisation;
  };
  virtualisation.vmVariantWithBootLoader = {
    inherit virtualisation;
  };
  virtualisation.libvirtd = {
    enable = true;

    qemu = {
      swtpm.enable = true;
      ovmf.enable = true;
      ovmf.packages = [(pkgs.OVMF.override {
        secureBoot = true;
        tpmSupport = true;
      }).fd];
    };
  };

  virtualisation.spiceUSBRedirection.enable = true;

  virtualisation.podman = {
    enable = true;
    # Create the default bridge network for podman.
    defaultNetwork.settings.dns_enabled = true;
  };
  boot.binfmt = {
    emulatedSystems = [ "aarch64-linux" ];
    # Required for Podman.
    preferStaticEmulators = true;
  };
}

