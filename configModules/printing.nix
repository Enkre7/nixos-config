{ config, pkgs, ... }:

{
  services.printing = {
    enable = true;
    drivers = with pkgs; [ brgenml1cupswrapper gutenprint ];
  };
  programs.system-config-printer.enable = true;
  
  hardware.sane = {
    enable = true;
    brscan4 = {
      enable = true;
      netDevices = {
        brother = {
          model = "MFC-7860DW";
          nodename = "Brother-MFC-7860DW";
        };
      };
    };
  };
  
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };
  services.printing = {
    listenAddresses = [ "*:631" ];
    allowFrom = [ "all" ];
    browsing = true;
    defaultShared = true;
    openFirewall = true;
  };
  
  services.ipp-usb.enable = true;
  users.users.${config.user}.extraGroups = [ "scanner" "lp" ];

  environment.systemPackages = with pkgs; [ simple-scan system-config-printer gscan2pdf ];
}
