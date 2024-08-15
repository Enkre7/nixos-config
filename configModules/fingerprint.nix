{ config, ... }:

{
  # Print Scanner
  systemd.services.fprintd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "simple";
  };
  security.polkit.enable = true;
  services.fprintd.enable = true; # sudo fprintd-enroll <user> & fprintd-verify
  security.pam.services = {
    hyprlock = {};
    hyprlock.fprintAuth = true;
    greetd.fprintAuth = true;
    greetd.gnupg.enable = true;
  };  
}
