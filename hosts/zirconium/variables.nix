{ config, pkgs, lib, ... }:

{
  options = with lib; with types; {
    stateVersion = mkOption { type = str; };
    hostname = mkOption { type = str; };
    user = mkOption { type = str; };
    flakePath = mkOption { type = str; };
    dotfilesPath = mkOption { type = str; };
    wallpaper = mkOption { type = str; };
    styleTheme = mkOption { type = str; };
    stylePolarity = mkOption { type = str; };
    gitUsername = mkOption { type = str; };
    gitEmail = mkOption { type = str; };
    
    # Options for battery.nix
    hasLaptopBattery = mkOption {
      type = types.bool;
      default = false;
    };
    cpuVendor = mkOption {
      type = types.enum [ "AMD" "Intel" "unknown" ];
      default = "unknown";
    };
    isFrameworkDevice = mkOption {
      type = types.bool;
      default = false;
    };
  };
  
  config = {
    stateVersion = "25.05";
    hostname = "zirconium";
    user = "enkre";
    flakePath = "/persist/system/nixos";
    dotfilesPath = "${config.flakePath}/dotfiles";
    wallpaper = "${config.dotfilesPath}/wallpapers/everforest-circuit_closeup.png"; # only png
    styleTheme = "everforest";
    stylePolarity = "dark";
    gitUsername = "Enkre7";
    gitEmail = "victor.mairot@proton.me";
    hasLaptopBattery = false;
    cpuVendor = "AMD";
    isFrameworkDevice = false;
  };
}
