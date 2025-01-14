{ pkgs, ... }:

{
  home.packages = with pkgs; [ onlyoffice-bin ];

  xdg.mimeApps.defaultApplications = {
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "onlyoffice";
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = "onlyoffice";
    "application/vnd.openxmlformats-officedocument.presentationml.presentation" = "onlyoffice";
    "application/msword" = "onlyoffice";
    "application/vnd.ms-excel" = "onlyoffice";
    "application/vnd.ms-powerpoint" = "onlyoffice";
    "application/rtf" = "onlyoffice";
  };
}
