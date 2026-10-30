{ config, pkgs, ... }:

{
  # Printing
  services.printing = {
    enable = true;
    drivers = with pkgs; [ brgenml1cupswrapper gutenprint ];
    listenAddresses = [ "localhost:631" ];
    allowFrom = [ "localhost" ];
    browsing = false;
    defaultShared = false;
    openFirewall = false;
    browsed.enable = false;
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
    settings.publish = {
      disable-publishing = false;
      disable-user-service-publishing = false;
      publish-addresses = true;
    };
  };
  
  users.users.${config.user}.extraGroups = [ "scanner" "lp" ];

  environment.systemPackages = with pkgs; [ 
    # Printing
    system-config-printer
    # Scanner
    simple-scan
  ];
}
