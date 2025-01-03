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
  };
  
  config = {
    stateVersion = "25.05";
    hostname = "promethium";
    user = "enkre";
    flakePath = "/persist/system/nixos";
    dotfilesPath = "${config.flakePath}/dotfiles";
    wallpaper = "${config.dotfilesPath}/wallpapers/nord-light-mountains.png"; # only png
    styleTheme = "nord-light";
    stylePolarity = "light";
    gitUsername = "Enkre7";
    gitEmail = "victor.mairot@proton.me";
  };
}
