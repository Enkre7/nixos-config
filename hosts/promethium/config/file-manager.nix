{ pkgs, lib, inputs, ... }:
 
{
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  xdg.mime.defaultApplications = {
    "inode/directory" = "thunar.desktop";
  };

  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
    thunar-media-tags-plugin
  ];
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.gvfs.package = pkgs.gnome3.gvfs;
  services.tumbler.enable = true; # Thumbnail support for images
  programs.file-roller.enable = true; # Archive support
  services.devmon.enable = true; 
  services.udisks2.enable = true;
  environment.systemPackages = with pkgs; [ libsForQt5.full zip unzip usbutils udiskie ];
}
