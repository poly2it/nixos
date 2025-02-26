{ pkgs, ... }:

{
  services.printing = {
    enable = true;
    drivers = with pkgs; [ gutenprint hplip splix ];

    # Remove "Manage Printing" .desktop file
    package = pkgs.symlinkJoin {
      inherit (pkgs.cups) name pname version;
      paths = [pkgs.cups];
      postBuild = ''
        unlink $out/share/applications/cups.desktop
      '';
    };
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
