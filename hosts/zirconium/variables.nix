{ config, pkgs, lib, inputs, ... }:

let
  secrets = import "${inputs.secrets}/secrets.nix";
in
{
  options = with lib; with types; {
    stateVersion = mkOption { type = str; };
    hostname = mkOption { type = str; };
    user = mkOption { type = str; };
    flakePath = mkOption { type = str; };
    dotfilesPath = mkOption { type = str; };
    wallpaper = mkOption { type = path; };
    styleTheme = mkOption { type = str; };
    stylePolarity = mkOption { type = str; };
    gitUsername = mkOption { type = str; };
    gitEmail = mkOption { type = str; };
    searxngURL = mkOption { type = str; };    
    firefoxSyncURL = mkOption { type = str; };
    hashedPassword = mkOption { type = str; };
    bitwardenURL = mkOption { type = str; };
    nextcloudPath = mkOption { type = str; };
    avatarPath = mkOption { type = str; };
    
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
    stateVersion = "26.11";
    hostname = "zirconium";
    user = secrets.user;
    flakePath = "/etc/nixos";
    dotfilesPath = "${config.flakePath}/dotfiles";
    wallpaper = ../../dotfiles/wallpapers/dark/everforest-dark-mist_forest.png; # only png
    styleTheme = "everforest";
    stylePolarity = "dark";
    gitUsername = secrets.gitUsername;
    gitEmail = secrets.gitEmail;
    searxngURL = secrets.searxngURL;
    firefoxSyncURL = secrets.firefoxSyncURL;
    hashedPassword = secrets.hashedPassword;
    bitwardenURL = secrets.bitwardenURL;
    nextcloudPath = secrets.nextcloudPath;
    avatarPath = secrets.avatarPath;
    isLaptop = false;
    cpuVendor = "AMD";
    isFrameworkDevice = false;
    kernelPackage = pkgs.linuxPackages_latest;
  };
}
