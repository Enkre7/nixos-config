{ pkgs, lib, ... }:
 
{
  xdg.portal = {
    enable = true;
    wlr.enable = true;  
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
    config = {
      common = {
        default = [ "wlr" "gtk" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        "org.freedesktop.impl.portal.Print" = [ "gtk" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
        "org.freedesktop.impl.portal.Wallpaper" = [ "wlr" ];
      };
      
      sway.default = [ "wlr" "gtk" ];
      niri.default = [ "wlr" "gtk" ];
    };
  };
}
