{ lib, pkgs, config, ... }:

{
  services.gnome.gnome-keyring.enable = true;

  # Automatically unlock keyring on LUKS passphrase.
  security.pam.services.gdm.enableGnomeKeyring = true;
  boot.initrd.systemd.enable = lib.mkForce true;
  security.pam.services.gdm-autologin.text = lib.mkForce ''
    auth      requisite     pam_nologin.so
    auth      required      pam_succeed_if.so uid >= 1000 quiet
    ${lib.optionalString config.security.pam.services.login.enableGnomeKeyring ''
      auth       [success=ok default=1]      ${pkgs.gdm}/lib/security/pam_gdm.so
      auth       optional                    ${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so
    ''}
    auth      required      pam_permit.so

    account   sufficient    pam_unix.so

    password  requisite     pam_unix.so nullok yescrypt

    session   optional      pam_keyinit.so revoke
    session   include       login
  '';
}

