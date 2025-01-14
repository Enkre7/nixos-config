{ pkgs, ... }:

{
  programs.mpv = {
      enable = true;
      scripts = [pkgs.mpvScripts.mpris];
  };

  xdg.mimeApps.defaultApplications = {
    "audio/mpeg" = "mpv";
    "audio/ogg" = "mpv";
    "video/mp4" = "mpv";
    "video/x-matroska" = "mpv";
    "video/webm" = "mpv";
    "audio/x-flac" = "mpv";
    "audio/x-wav" = "mpv";
    "audio/x-mp3" = "mpv";
    "audio/x-ogg" = "mpv";
  };
}
