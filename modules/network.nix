{ ... }:

{
  # https://community.torproject.org/relay/setup/exit/#dns-on-exit-relays
  # TOR recommends Unbound as one's DNS resolver.
  services.unbound = {
    enable = false;
    settings = {
      server = {
        interface = ["127.0.0.1"];
        port = 5335;
        access-control = ["127.0.0.1 allow"];

        # Based on recommended settings in https://docs.pi-hole.net/guides/dns/unbound/#configure-unbound
        harden-glue = true;
        harden-dnssec-stripped = true;
        use-caps-for-id = false;
        prefetch = true;
        edns-buffer-size = 1232;

        hide-identity = true;
        hide-version = true;
      };
    };
  };

  services.resolved = {
    enable = true;
    dnssec = "true";
  };

  networking.resolvconf.useLocalResolver = true;

  networking.networkmanager.enable = true;

  networking.firewall.allowedTCPPorts = [
    # I2P.
    4444
    4445
    4447
    7656
    7657
    7658
    7659
    7660
  ];

  services.i2pd = rec {
    enable = true;
    enableIPv6 = false;
    address = "127.0.0.1";
    bandwidth = 32768;
    proto.http = {
      enable = true;
      inherit address;
    };
    proto.httpProxy = {
      enable = true;
      inherit address;
      port = 4444;
    };
    proto.socksProxy = {
      enable = true;
      inherit address;
      port = 4447;
    };
  };
}

