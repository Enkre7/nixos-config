{ config, pkgs, lib, inputs, vars, ... }:

{
  imports = [
    ./variables.nix
    #../../homeModules/impermanence.nix
    ../../homeModules/wlogout.nix
    ../../homeModules/waybar.nix
    ../../homeModules/light.nix
    ../../homeModules/notification.nix
    ../../homeModules/capture.nix
    ../../homeModules/hyprland.nix
    ../../homeModules/hyprlock.nix
    ../../homeModules/hypridle.nix
    ../../homeModules/firefox.nix
    ../../homeModules/git.nix
    ../../homeModules/vscode.nix
    ../../homeModules/shell.nix
    ../../homeModules/terminal.nix
    ../../homeModules/kdeconnect.nix
    ../../homeModules/wofi.nix
  ];

  home.username = config.user;
  home.homeDirectory = "/home/${config.user}";
  home.stateVersion = "24.05";
  nixpkgs.config.allowUnfreePredicate = _: true;
  
  stylix.autoEnable = true;
  stylix.targets.kde.enable = false;
  stylix.targets.wofi.enable = false;
  
  wayland.windowManager.hyprland.settings = {
    monitor = lib.mkForce ",highrr,auto,1.333333";
    general.gaps_in = lib.mkForce 4;
    general.gaps_out = lib.mkForce 7;
  }; 
    
  programs.home-manager.enable = true;
  
  programs.mpv = {
      enable = true;
      scripts = [pkgs.mpvScripts.mpris];
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
}
