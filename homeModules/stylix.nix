{ pkgs, ... }:

{
  stylix.targets.kde.useWallpaper = false;
  stylix.targets.wofi.enable = false; 
  stylix.targets.rofi.enable = false; 
  stylix.targets.hyprlock.enable = false;
  stylix.targets.waybar.addCss = false;
  stylix.iconTheme = {
    enable = true;
    package = pkgs.papirus-icon-theme;
    #package = pkgs.papirus-icon-theme.override { color = "green"; };
    light = "Papirus-Light";
    dark = "Papirus-Dark";
  };
}
