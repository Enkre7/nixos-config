{ pkgs, ... }:
 
{
  xdg.portal = {
    enable = true;
    wlr.enable = true;  
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
    config = {
      common.default = ["hyprland" "gtk"];
      hyprland.default = ["wlr" "gtk"];
    };
  };
}
