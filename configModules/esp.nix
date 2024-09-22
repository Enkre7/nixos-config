{ config, ... }:

{
  programs.chromium.enable = true;
  
  environment.systemPackages = with pkgs; [
    esphome
    esptool
  ];
}
