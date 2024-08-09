{ config, pkgs, lib, ... }:

{
  options = with lib; with types; {
    hostname = mkOption { type = str; };
    user = mkOption { type = str; };
    flakePath = mkOption { type = str; };
    dotfilesPath = mkOption { type = str; };
    wallpaper = mkOption { type = str; };
    stylePolarity = mkOption { type = str; };
    gitUsername = mkOption { type = str; };
    gitEmail = mkOption { type = str; };
  };
  config = {
    hostname = "promethium";
    user = "enkre";
    flakePath = "/etc/nixos";
    dotfilesPath = "${config.flakePath}/.dotfiles";
    wallpaper = "${config.dotfilesPath}/wallpapers/nord-light-mountains.png"; # only png
    stylePolarity = "light";
    gitUsername = "Enkre7";
    gitEmail = "victor.mairot@proton.me";
  };
}
