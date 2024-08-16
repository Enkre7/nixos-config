{ config, pkgs, lib, ... }:

{
  options = with lib; with types; {
    version = mkOption { type = str; };
    hostname = mkOption { type = str; };
    user = mkOption { type = str; };
    flakePath = mkOption { type = str; };
    dotfilesPath = mkOption { type = str; };
    wallpaper = mkOption { type = str; };
    styleTheme = mkOption { type = str; };
    stylePolarity = mkOption { type = str; };
    gitUsername = mkOption { type = str; };
    gitEmail = mkOption { type = str; };
  };
  
  config = {
    version = "24.11";
    hostname = "zirconium";
    user = "enkre";
    flakePath = "/persist/system/nixos";
    dotfilesPath = "${config.flakePath}/dotfiles";
    wallpaper = "${config.dotfilesPath}/wallpapers/everforest-circuit_closeup.png"; # only png
    styleTheme = "everforest";
    stylePolarity = "dark";
    gitUsername = "Enkre7";
    gitEmail = "victor.mairot@proton.me";
  };
}
