{ pkgs, ... }:
 
{
  xdg.portal = {
    enable = true;
    wlr.enable = true;  
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };
  xdg.mime.defaultApplications = {
    "inode/directory" = "thunar.desktop";
    "application/x-zip" = "file-roller.desktop";
    "application/x-gzip" = "file-roller.desktop";
    "application/x-bzip2" = "file-roller.desktop";
    "application/x-xz" = "file-roller.desktop";
    "application/zip" = "file-roller.desktop";
    "application/gzip" = "file-roller.desktop";
    "application/x-7z-compressed" = "file-roller.desktop";
    "application/x-rar" = "file-roller.desktop";
    "application/x-tar" = "file-roller.desktop";
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
