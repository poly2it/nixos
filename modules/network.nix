{ ... }:

{
  # https://community.torproject.org/relay/setup/exit/#dns-on-exit-relays
  # TOR recommends Unbound as one's DNS resolver.
  services.unbound = {
    enable = true;
    settings = {
      forward-zone = [
        {
          name = ".";
          forward-tls-upstream = true;
          forward-addr = "194.242.2.2@853#dns.mullvad.net";
        }
      ];
      server = {
        interface = ["127.0.0.1"];
        port = 53;
        access-control = ["127.0.0.1 allow"];

        # verbosity = 1;
        # log-queries = true;
        # log-replies = true;

        # Based on recommended settings in https://docs.pi-hole.net/guides/dns/unbound/#configure-unbound
        harden-glue = true;
        harden-dnssec-stripped = true;
        use-caps-for-id = false;
        prefetch = true;
        edns-buffer-size = 1232;

        hide-identity = true;
        hide-version = true;

        do-not-query-localhost = false;
        edns-tcp-keepalive = true;

        # Define local data for your domain
        local-data = [
          "'cenitly.local. A 127.0.0.1'"
          "'auth.cenitly.local. A 127.0.0.1'"
        ];
        local-data-ptr = ''"127.0.0.1 cenitly.local"'';

        # Make sure .local queries are handled locally
        private-domain = ''"local"'';
        domain-insecure = ''"local"'';
      };
    };
  };

  networking.nameservers = [ "127.0.0.1" ];

  services.resolved.enable = false;

  networking.resolvconf.useLocalResolver = true;

  networking.wireless.iwd.enable = true;
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };

  networking.nftables = {
    enable = true;
    tables = {
      mullvad_tailscale = {
        name = "mullvad_tailscale";
        family = "inet";
        content = ''
          chain output {
            type route hook output priority -100; policy accept;
            ip daddr 100.64.0.0/10 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
          }

          chain input {
            type filter hook input priority -100; policy accept;
            ip saddr 100.64.0.0/10 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
          }
        '';
      };
      cenitly_local = {
        name = "cenitly_local";
        family = "ip";
        content = ''
          chain output {
            type nat hook output priority -100; policy accept;
            ip daddr 127.0.0.1 tcp dport 80 redirect to :7080
          }
        '';
      };
      cenitly_local_tls = {
        name = "cenitly_local_tls";
        family = "ip";
        content = ''
          chain output {
            type nat hook output priority -100; policy accept;
            ip daddr 127.0.0.1 tcp dport 443 redirect to :7443
          }
        '';
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [
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
  };

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

  services.tailscale = {
    enable = true;
    # Open firewall for the tunnel port.
    openFirewall = true;
    port = 41641;
  };
}

