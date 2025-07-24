{ ... }:

{
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = null;
    publicShare = null;
    templates = null;
  };
  xdg.mimeApps.enable = true;
  xdg.configFile."mimeapps.list".force = true;
}
