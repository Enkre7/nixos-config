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
    searxngURL = mkOption { type = str; };    
    firefoxSyncURL = mkOption { type = str; };
    
    # Options for battery.nix
    isLaptop = mkOption {
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

    kernelPackage = mkOption {               
      type = types.attrs;
      description = "Kernel package to use (e.g. pkgs.linuxPackages_zen)";
    };
  };
  
  config = {
    stateVersion = "25.05";
    hostname = "zirconium";
    user = "enkre";
    flakePath = "/etc/nixos";
    dotfilesPath = "${config.flakePath}/dotfiles";
    wallpaper = "${config.dotfilesPath}/wallpapers/everforest-mist_forest.png"; # only png
    styleTheme = "everforest";
    stylePolarity = "dark";
    gitUsername = "Enkre7";
    gitEmail = "victor.mairot@proton.me";
    searxngURL = "searxng.7mairot.com";
    firefoxSyncURL = "firefoxsyncserver.7mairot.com";
    isLaptop = false;
    cpuVendor = "AMD";
    isFrameworkDevice = false;
    kernelPackage = pkgs.linuxPackages_latest;
  };
}
