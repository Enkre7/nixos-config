{ ... }:

{
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = false;
    desktop = null;
    publicShare = null;
  };
  xdg.mimeApps.enable = true;
  xdg.configFile."mimeapps.list".force = true;

  xdg.mimeApps.defaultApplications = {
    "application/x-drawio" = "drawio.desktop";
    "application/vnd.jgraph.mxfile" = "drawio.desktop";

    "application/zip" = "org.gnome.FileRoller.desktop";
    "application/x-zip-compressed" = "org.gnome.FileRoller.desktop";
    "application/gzip" = "org.gnome.FileRoller.desktop";
    "application/x-7z-compressed" = "org.gnome.FileRoller.desktop";
    "application/x-rar" = "org.gnome.FileRoller.desktop";
    "application/x-rar-compressed" = "org.gnome.FileRoller.desktop";
    "application/x-tar" = "org.gnome.FileRoller.desktop";
    "application/x-compressed-tar" = "org.gnome.FileRoller.desktop";
    "application/x-bzip2" = "org.gnome.FileRoller.desktop";
    "application/x-xz" = "org.gnome.FileRoller.desktop";
  };
}
