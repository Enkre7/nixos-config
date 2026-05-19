{ lib, pkgs, ... }:

{
  services.fprintd.enable = true;

  systemd.services.fprintd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "simple";
  };

  security.pam.services = {
    login.fprintAuth = lib.mkForce true;
    hyprlock.fprintAuth = lib.mkForce true;
    greetd.fprintAuth = true;
    sudo.fprintAuth = true;
    sshd.fprintAuth = true;
    polkit-1.fprintAuth = true;
    su.fprintAuth = true;
    passwd.fprintAuth = true;
  };
}
