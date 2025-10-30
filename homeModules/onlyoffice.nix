{ pkgs, ... }:

{
  home.packages = with pkgs; [ onlyoffice-desktopeditors ];

  xdg.mimeApps.defaultApplications = {
    "application/vnd.oasis.opendocument.presentation" = "onlyoffice";
    "application/vnd.oasis.opendocument.spreadsheet" = "onlyoffice";
    "application/vnd.oasis.opendocument.text" = "onlyoffice";
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "onlyoffice";
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = "onlyoffice";
    "application/vnd.openxmlformats-officedocument.presentationml.presentation" = "onlyoffice";
    "application/msword" = "onlyoffice";
    "application/vnd.ms-excel" = "onlyoffice";
    "application/vnd.ms-powerpoint" = "onlyoffice";
    "application/vnd.ms-fontobject" = "onlyoffice";
    "application/rtf" = "onlyoffice";
    "text/csv" = "onlyoffice";
  };
}
