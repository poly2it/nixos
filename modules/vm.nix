{ ... }:

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

