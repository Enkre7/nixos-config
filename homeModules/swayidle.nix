{ pkgs, ... }:

{
  services.swayidle = {
    enable = true;
    package = pkgs.swayidle;
    systemdTarget = "graphical-session.target";
    
    events = [
      { event = "before-sleep"; command = "${pkgs.hyprlock}/bin/hyprlock"; }
      { event = "lock"; command = "${pkgs.hyprlock}/bin/hyprlock"; }
    ];
    
    timeouts = [
      { 
        timeout = 600; 
        command = "${pkgs.hyprlock}/bin/hyprlock"; 
      }
    ];
    
    extraArgs = [ "-w" ];
  };
}
