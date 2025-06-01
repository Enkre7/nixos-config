{ config, pkgs, ... }:

{
  # Razer peripherals and AIO support
  hardware.openrazer.enable = true;
  environment.systemPackages = with pkgs; [ openrazer-daemon polychromatic i2c-tools liquidctl];
  users.users.${config.user}.extraGroups = [ "openrazer" ];
  programs.coolercontrol = {
    enable = true;
    nvidiaSupport = true;  
  };


  # RGB controller
  boot = {
    kernelParams = [ "acpi_enforce_resources=lax" ];
    kernelModules = [ "i2c-dev" "i2c-piix4" ];
  };

  hardware.i2c.enable = true;
  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
    motherboard = "amd";
  };  

  networking.firewall = {
    allowedTCPPorts = [ 6742 ]; # OpenRGB server
    allowedUDPPorts = [ 6742 ];
  };
}
