{ config, ... }:

{
  programs.home-manager.enable = true; 
  home.username = config.user;
  home.homeDirectory = "/home/${config.user}";
  home.stateVersion = config.version;

  nixpkgs.config.allowUnfreePredicate = _: true;
} 
