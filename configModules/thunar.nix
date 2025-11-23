{ pkgs, ... }:
 
{
  xdg.mime.defaultApplications = {
    "inode/directory" = "thunar";
    "application/x-zip" = "file-roller";
    "application/x-gzip" = "file-roller";
    "application/x-bzip" = "file-roller";
    "application/x-bzip2" = "file-roller";
    "application/x-xz" = "file-roller";
    "application/zip" = "file-roller";
    "application/gzip" = "file-roller";
    "application/x-7z-compressed" = "file-roller";
    "application/x-rar-compressed" = "file-roller";
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
  services.devmon.enable = true; 
  services.udisks2.enable = true;
  environment.systemPackages = with pkgs; [ zip unzip usbutils udiskie file-roller ];
}
