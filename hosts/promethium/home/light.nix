{ pkgs, ... }:

{
  services.gammastep = {
    enable = true;
    provider = "manual";
    latitude = 43.2951;
    longitude = 5.3861;
    tray = true;
    temperature.day = 5500;
    temperature.night = 3700;
    settings.general.adjustment-method = "wayland";
  };
  
  home.packages = with pkgs; [ brightnessctl ];
}
