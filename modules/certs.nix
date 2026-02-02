{
config,
lib,
pkgs,
...
}:
let
  cfg = config.services.dynamic-ca;

  pkiCfg = config.security.pki;
  baseCacertPackage = pkgs.cacert.override {
    blacklist = pkiCfg.caCertificateBlacklist;
    extraCertificateFiles = pkiCfg.certificateFiles;
    extraCertificateStrings = pkiCfg.certificates;
  };

  caBundleName = if pkiCfg.useCompatibleBundle then "ca-no-trust-rules-bundle.crt" else "ca-bundle.crt";
  baseBundle = "${baseCacertPackage}/etc/ssl/certs/${caBundleName}";
in
  {
  options.services.dynamic-ca = {
    enable = lib.mkEnableOption "dynamic certificate authority management";

    dynamicCertsDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/dynamic-certs";
      description = "Directory to watch for dynamic certificates (.crt or .pem files).";
    };

    outputBundle = lib.mkOption {
      type = lib.types.path;
      default = "/run/dynamic-ca/ca-certificates.crt";
      description = "Output path for the merged certificate bundle.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d ${cfg.dynamicCertsDir} 0755 root root -"
      "d ${builtins.dirOf cfg.outputBundle} 0755 root root -"
      "L+ /etc/ssl/certs/ca-certificates.crt - - - - ${cfg.outputBundle}"
      "L+ /etc/ssl/certs/ca-bundle.crt - - - - ${cfg.outputBundle}"
      "L+ /etc/pki/tls/certs/ca-bundle.crt - - - - ${cfg.outputBundle}"
    ];

    systemd.services.dynamic-ca = {
      description = "Dynamic Certificate Authority Management";
      wantedBy = [ "multi-user.target" ];
      before = [ "network-pre.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.dynamic-certs |> lib.getExe} ${[
          "-base-bundle"
          baseBundle
          "-dynamic-dir"
          cfg.dynamicCertsDir
          "-output"
          cfg.outputBundle
        ] |> lib.escapeShellArgs}";
        Restart = "always";
        RestartSec = "5s";

        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadWritePaths = [
          cfg.dynamicCertsDir
          (builtins.dirOf cfg.outputBundle)
        ];
        BindReadOnlyPaths = [
          "/nix/store"
        ];
      };
    };
  };
}
