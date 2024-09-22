{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    chromium
    esphome
    esptool
  ];
}
