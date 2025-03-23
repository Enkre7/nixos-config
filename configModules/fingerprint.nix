{ ... }:

{
  systemd.services.fprintd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "simple";
  };

  services.fprintd.enable = true; # sudo fprintd-enroll <user> & fprintd-verify
  security.pam.services = {
    login.fprintAuth = true;
    greetd.fprintAuth = true;
    sudo.fprintAuth = true;
    hyprlock.fprintAuth = true;
    sshd.fprintAuth = true;
    polkit-1.fprintAuth = true;
    su.fprintAuth = true;
    passwd.fprintAuth = true;
  };  
}
