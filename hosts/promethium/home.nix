{ config, pkgs, lib, inputs, vars, ... }:

{
  imports = [
    ./variables.nix
    #../../homeModules/impermanence.nix
    ../../homeModules/wlogout.nix
    ../../homeModules/waybar.nix
    ../../homeModules/light.nix
    ../../homeModules/nix-index.nix
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
    ../../homeModules/libreoffice.nix
  ];

  home.username = config.user;
  home.homeDirectory = "/home/${config.user}";
  home.stateVersion = config.version;
  nixpkgs.config.allowUnfreePredicate = _: true;
  
  stylix.autoEnable = true;
  stylix.targets.kde.enable = false;
  stylix.targets.wofi.enable = false;
    
  programs.home-manager.enable = true;
  
  programs.mpv = {
      enable = true;
      scripts = [pkgs.mpvScripts.mpris];
    };

  home.packages = with pkgs; [
    webcord
    gnome-calculator
    nextcloud-client    
    qimgv
  ];
}
