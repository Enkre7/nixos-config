{ config, pkgs, ... }:

{
  # Printing
  services.printing = {
    enable = true;
    drivers = with pkgs; [ brgenml1cupswrapper gutenprint ];
    listenAddresses = [ "*:631" ];
    allowFrom = [ "all" ];
    browsing = true;
    defaultShared = true;
    openFirewall = true;
  };
  
  programs.system-config-printer.enable = true;
  
  # Scanner
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
  
  services.ipp-usb.enable = true;
  
  # Both
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };
  
  users.users.${config.user}.extraGroups = [ "scanner" "lp" ];

  environment.systemPackages = with pkgs; [ 
    # Printing
    system-config-printer
    # Scanner
    simple-scan
    gscan2pdf
  ];
}
