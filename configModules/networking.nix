{ config, lib, pkgs, ... }: 

{
  networking = {
    hostName = config.hostname;
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
    useDHCP = lib.mkDefault true;
    # interfaces.wlp1s0.useDHCP = lib.mkDefault true;
  };
  
  # Network discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
 
  #Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
  
  # Firewall
  networking.firewall.enable = false;
    
  # SSH
  services.openssh = {
    enable = true;
    settings = {
      # set to false, require public key authentication for better security
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ config.user ];
    };
  };
  
  environment.systemPackages = with pkgs; [
    wget
    curl
    iperf
    nmap
    netcat
    networkmanagerapplet
  ];
}
