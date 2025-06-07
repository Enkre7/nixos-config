{ pkgs, ... }:

{
  # Display server
  services.xserver = {
    enable = true;
    xkb.layout = "fr";
    xkb.variant = "";
    excludePackages = with pkgs; [ xterm ];
    displayManager.gdm.enable = true;
  };
  
  # Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
