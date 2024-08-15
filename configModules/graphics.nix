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
  #services.xserver.videoDrivers = ["amgpu"];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    #extraPackages = with pkgs; [ rocmPackages.clr.icd amdvlk ];
    #extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
  };
}
