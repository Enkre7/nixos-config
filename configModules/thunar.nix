{ pkgs, ... }:
 
{
  xdg.portal = {
    enable = true;
    wlr.enable = true;  
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };
  xdg.mime.defaultApplications = {
    "inode/directory" = "thunar";
    "application/x-zip" = "file-roller";
    "application/x-gzip" = "file-roller";
    "application/x-bzip2" = "file-roller";
    "application/x-xz" = "file-roller";
    "application/zip" = "file-roller";
    "application/gzip" = "file-roller";
    "application/x-7z-compressed" = "file-roller";
    "application/x-rar" = "file-roller";
    "application/x-tar" = "file-roller";
  };

  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
    thunar-media-tags-plugin
  ];
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.gvfs.package = pkgs.gnome.gvfs;
  services.tumbler.enable = true; # Thumbnail support for images
  programs.file-roller.enable = true; # Archive support
  services.devmon.enable = true; 
  services.udisks2.enable = true;
  environment.systemPackages = with pkgs; [ libsForQt5.full zip unzip usbutils udiskie ];
}
