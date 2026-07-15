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
    protonCalendarUrl = mkOption { type = str; };

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
    stateVersion = "26.05";
    hostname = "promethium";
    user = "enkre";
    flakePath = "/etc/nixos";
    dotfilesPath = "${config.flakePath}/dotfiles";
    wallpaper = ../../dotfiles/wallpapers/dark/nord-dark-heracles.png; # only png
    styleTheme = "nord"; #gruvbox-light
    stylePolarity = "dark";
    gitUsername = "Enkre7";
    gitEmail = "victor.mairot@proton.me";
    searxngURL = "searxng.7mairot.com";
    firefoxSyncURL = "firefoxsyncserver.7mairot.com";
    protonCalendarUrl = "https://calendar.proton.me/api/calendar/v1/url/tw9unwlYgWjJrPhfWEDLiHkT8B0XP2MSJEY1jx9Pk18BlLgUI1n2oIWrSWOGC1-Em2nrTeo4qicLSpZu_zN87A==/calendar.ics?CacheKey=CInFC25Kbi7pfheWUP78KA%3D%3D&PassphraseKey=vNYxf0PgsLlzISbS4LkFsntI6f94AEPL9VUbUT3V8cw%3D";
    isLaptop = true;
    cpuVendor = "AMD";
    isFrameworkDevice = true;
    kernelPackage = pkgs.linuxPackages_latest;
  };
}
