{ lib, ... }:

{
  systemd.services.fprintd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "simple";
  };

  services.fprintd.enable = true; # sudo fprintd-enroll <user> & fprintd-verify
  security.pam.services = {
    login.fprintAuth = lib.mkForce true;
    greetd.fprintAuth = true;
    hyprlock.fprintAuth = true;
    sudo.fprintAuth = true;
    sshd.fprintAuth = true;
    polkit-1.fprintAuth = true;
    su.fprintAuth = true;
    passwd.fprintAuth = true;
  };  
}
