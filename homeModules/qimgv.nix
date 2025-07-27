{ pkgs, ... }:

{
  home.packages = with pkgs; [ qimgv ];

  xdg.configFile."qimgv/qimgv.conf" = {
    text = ''
      [General]
      JPEGSaveQuality=95
      backgroundOpacity=0.48
      autoResizeWindow=false
      useSystemColorScheme=true
      scalingFilter=3
      memoryAllocationLimit=1024
      enableSmoothScroll=true
      smoothUpscaling=true
    '';
    force = false;
  };

  xdg.mimeApps.defaultApplications = {
    "image/svg+xml" = "qimgv.desktop";
    "image/jpeg" = "qimgv.desktop";
    "image/png" = "qimgv.desktop";
    "image/webp" = "qimgv.desktop";
    "image/gif" = "qimgv.desktop";
    "image/bmp" = "qimgv.desktop";
    "image/tiff" = "qimgv.desktop";
    "image/x-ms-bmp" = "qimgv.desktop";
    "image/x-portable-pixmap" = "qimgv.desktop";
    "image/x-raw" = "qimgv.desktop";
    "image/vnd.microsoft.icon" = "qimgv.desktop";
    "image/x-icon" = "qimgv.desktop";
  };
}
