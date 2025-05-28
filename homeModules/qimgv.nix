{ pkgs, ... }:

{
  home.packages = with pkgs; [ qimgv ];

  xdg.mimeApps.defaultApplications = {
    "image/svg+xml" = "qimgv";
    "image/jpeg" = "qimgv";
    "image/png" = "qimgv";
    "image/webp" = "qimgv";
    "image/gif" = "qimgv";
    "image/bmp" = "qimgv";
    "image/tiff" = "qimgv";
    "image/x-ms-bmp" = "qimgv";
    "image/x-portable-pixmap" = "qimgv";
    "image/x-raw" = "qimgv";
    "image/vnd.microsoft.icon" = "qimgv";
    "application/epub+zip" = "qimgv";
    "application/vnd.amazon.ebook" = "qimgv";
    "image/x-icon" = "qimgv";
  };
}
