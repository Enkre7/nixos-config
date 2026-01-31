{ config, pkgs, lib, ... }:

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
    stateVersion = "25.11";
    hostname = "promethium";
    user = "enkre";
    flakePath = "/etc/nixos";
    dotfilesPath = "${config.flakePath}/dotfiles";
    wallpaper = ../../dotfiles/wallpapers/gruvbox-light-kojiro.png; # only png
    styleTheme = "gruvbox-light"; 
    stylePolarity = "light";
    gitUsername = "Enkre7";
    gitEmail = "victor.mairot@proton.me";
    searxngURL = "searxng.7mairot.com";
    firefoxSyncURL = "firefoxsyncserver.7mairot.com";
    isLaptop = true;
    cpuVendor = "AMD";
    isFrameworkDevice = true;
    kernelPackage = pkgs.linuxPackages_latest;
  };
}
