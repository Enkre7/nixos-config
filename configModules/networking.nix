{ config, pkgs, ... }: 

{
  networking.hostName = config.hostname;
  networking.networkmanager = {
    enable = true;
    wifi.powersave = false;
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
 
  # VPN
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;
  services.resolved.enable = true;

  services.tailscale.enable = true; 
 
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
  
  environment.systemPackages = with pkgs; [ networkmanagerapplet ];
}