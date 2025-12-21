{ pkgs, ... }:

{
  services.swayidle = {
    enable = true;
    package = pkgs.swayidle;
    systemdTarget = "graphical-session.target";
    
    events = {
      before-sleep = "${pkgs.hyprlock}/bin/hyprlock";
      lock = "${pkgs.hyprlock}/bin/hyprlock";
    };
    
    timeouts = [
      { 
        timeout = 600; 
        command = "${pkgs.hyprlock}/bin/hyprlock"; 
      }
    ];
    
    extraArgs = [ "-w" ];
  };
}
