{ pkgs, ... }:

{
  programs.mpv = {
      enable = true;
      scripts = [pkgs.mpvScripts.mpris];
  };

  xdg.mimeApps.defaultApplications = {
    "audio/mpeg" = [ "mpv.desktop" ];
    "audio/ogg" = [ "mpv.desktop" ];
    "video/mp4" = [ "mpv.desktop" ];
    "video/x-matroska" = [ "mpv.desktop" ];
    "video/webm" = [ "mpv.desktop" ];
    "audio/x-flac" = [ "mpv.desktop" ];
    "audio/x-wav" = [ "mpv.desktop" ];
    "audio/x-mp3" = [ "mpv.desktop" ];
    "audio/x-ogg" = [ "mpv.desktop" ];
  };
}
