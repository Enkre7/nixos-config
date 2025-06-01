{ pkgs, ... }:

{
  # Display server
  services.desktopManager.gnome.enable = true;
  services.xserver = {
    enable = true;
    xkb.layout = "fr";
    xkb.variant = "";
    excludePackages = with  pkgs; [ xterm ];
  };
  
  # Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
