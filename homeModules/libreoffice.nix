{ pkgs, ... }:

{
  home.packages = with pkgs; [
    libreoffice-fresh
    hunspell
    hunspellDicts.fr-any
  ];

  xdg.mimeApps.defaultApplications = {
    "application/vnd.oasis.opendocument.text" = "libreoffice --writer";
    "application/vnd.oasis.opendocument.spreadsheet" = "libreoffice --calc";
    "application/vnd.oasis.opendocument.presentation" = "libreoffice --impress";
    "application/msword" = "libreoffice --writer";
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "libreoffice --writer";
    "application/vnd.ms-excel" = "libreoffice --calc";
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = "libreoffice --calc";
    "application/vnd.ms-powerpoint" = "libreoffice --impress";
    "application/vnd.openxmlformats-officedocument.presentationml.presentation" = "libreoffice --impress";
    "application/pdf" = "libreoffice --draw";
    "application/rtf" = "libreoffice --writer";
    "application/vnd.sun.xml.writer" = "libreoffice --writer";
    "application/vnd.sun.xml.calc" = "libreoffice --calc";
    "application/vnd.sun.xml.impress" = "libreoffice --impress";
    "application/vnd.oasis.opendocument.graphics" = "libreoffice --draw";
    "application/x-iso9660-image" = "libreoffice --draw";
  };
}
