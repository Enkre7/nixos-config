{ config, pkgs, ... }:

{
  services.printing = {
    enable = true;
    drivers = with pkgs; [ brgenml1cupswrapper ];
  };
  programs.system-config-printer.enable = true;
  hardware.sane = {
    enable = true; # scanner
    brscan4.enable = true;
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };
  services.ipp-usb.enable = true; # Microsoft WSD "driverless" scanning
  users.users.${config.user}.extraGroups = [ "scanner" "lp" ];

  environment.systemPackages = with pkgs; [ simple-scan ];
}
