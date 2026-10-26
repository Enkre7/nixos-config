{ pkgs, ... }:
 
{
  xdg.mime.defaultApplications = {
    "inode/directory" = "thunar";
    "application/x-zip" = "org.gnome.FileRoller.desktop";
    "application/x-gzip" = "org.gnome.FileRoller.desktop";
    "application/x-bzip" = "org.gnome.FileRoller.desktop";
    "application/x-bzip2" = "org.gnome.FileRoller.desktop";
    "application/x-xz" = "org.gnome.FileRoller.desktop";
    "application/zip" = "org.gnome.FileRoller.desktop";
    "application/gzip" = "org.gnome.FileRoller.desktop";
    "application/x-7z-compressed" = "org.gnome.FileRoller.desktop";
    "application/x-rar-compressed" = "org.gnome.FileRoller.desktop";
    "application/x-tar" = "org.gnome.FileRoller.desktop";
  };

  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs; [
    thunar-archive-plugin
    thunar-volman
    thunar-media-tags-plugin
  ];
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.gvfs.package = pkgs.gnome.gvfs;
  services.tumbler.enable = true; # Thumbnail support for images
  services.devmon.enable = true; 
  services.udisks2.enable = true;
  environment.systemPackages = with pkgs; [ zip unzip usbutils udiskie file-roller gparted ];
}
