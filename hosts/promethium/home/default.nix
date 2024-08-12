{ config, pkgs, lib, inputs, vars, ... }:

{
  imports = [
    inputs.hyprland.homeManagerModules.default
    ../variables.nix
    #./impermanence.nix
    ./wlogout.nix
    ./waybar.nix
    ./light.nix
    ./nix-index.nix
    ./notification.nix
    ./capture.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./hypridle.nix
    ./firefox.nix
    ./git.nix
    ./vscode.nix
    ./shell.nix
    ./terminal.nix
    ./kdeconnect.nix
    ./wofi.nix
  ];

  home.username = config.user;
  home.homeDirectory = "/home/${config.user}";
  home.stateVersion = "24.05";
  nixpkgs.config.allowUnfreePredicate = _: true;
  
  stylix.autoEnable = true;
  stylix.targets.kde.enable = false;
  stylix.targets.wofi.enable = false;
    
  programs = {
    home-manager.enable = true;
    mpv = {
      enable = true;
      scripts = [pkgs.mpvScripts.mpris];
    };
  };

  home.packages = with pkgs; [
    webcord
    meld #git diff/merge tool
    gnome-calculator
    #calcure # Calendar
    nextcloud-client
    libreoffice-qt
    qimgv

    # Terminal widgets
    cmatrix
    pipes-rs
    rsclock
    figlet
  ];

  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\\\${HOME}/.steam/root/compatibilitytools.d";
  };
}
