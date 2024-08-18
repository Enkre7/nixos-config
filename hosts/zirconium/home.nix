{ config, pkgs, lib, inputs, vars, ... }:

{
  imports = [
    ./variables.nix
    ../../homeModules/home-manager.nix
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
    ../../homeModules/libreoffice.nix
  ];

  # Host specific settings
  
  wayland.windowManager.hyprland.settings = {
    monitor = lib.mkForce ",highrr,auto,1.333333";
    general.gaps_in = lib.mkForce 4;
    general.gaps_out = lib.mkForce 7;
  }; 
  
  xsession.numlock.enable = true;
  
  programs.mpv = {
      enable = true;
      scripts = [pkgs.mpvScripts.mpris];
    };

  home.packages = with pkgs; [
    webcord
    gnome-calculator
    nextcloud-client
    qimgv
    ffmpeg-full
  ];
}
