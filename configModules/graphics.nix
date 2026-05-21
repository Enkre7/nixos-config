{ pkgs, ... }:

{
  # Display server
  services.xserver = {
    enable = true;
    xkb.layout = "fr";
    xkb.variant = "";
    excludePackages = with pkgs; [ xterm ];
  };
  
  # Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      mesa
      libva
      libvdpau-va-gl
      libva-vdpau-driver
    ];
  };
}
