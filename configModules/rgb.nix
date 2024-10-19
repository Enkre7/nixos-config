{ config, pkgs, ... }:

{
  # Razer peripherals and AIO support
  hardware.openrazer.enable = true;
  environment.systemPackages = with pkgs; [ openrazer-daemon polychromatic liquidctl ];
  users.users.${config.user}.extraGroups = [ "openrazer" ];
  programs.coolercontrol = {
    enable = true;
    nvidiaSupport = true;  
  };

  # RGB controller
  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
  };
}
