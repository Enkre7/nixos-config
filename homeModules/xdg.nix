{ ... }:

{
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = null;
    publicShare = null;
  };
  xdg.mimeApps.enable = true;
  xdg.configFile."mimeapps.list".force = true;

  xdg.mimeApps.defaultApplications = {
    "application/x-drawio" = "drawio.desktop";
    "application/vnd.jgraph.mxfile" = "drawio.desktop";
  };
}
