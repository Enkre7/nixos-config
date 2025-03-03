{ pkgs, ... }:

{
  # Display server
  services.xserver = {
    enable = true;
    xkb.layout = "fr";
    xkb.variant = "";
    displayManager.gdm.enable = true;
    excludePackages = with  pkgs; [ xterm ];
  };
  
  # Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
