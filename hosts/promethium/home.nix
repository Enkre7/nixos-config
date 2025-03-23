{ config, pkgs, lib, inputs, vars, ... }:

{
  imports = [
  # Core
    ./variables.nix
    ../../homeModules/stylix.nix
    #../../homeModules/impermanence.nix
    ../../homeModules/nix-index.nix  
  # Desktop Environment
    ../../homeModules/hyprland.nix
    ../../homeModules/hyprlock.nix
    #../../homeModules/hypridle.nix
    ../../homeModules/waybar.nix
    ../../homeModules/wofi.nix
    ../../homeModules/wlogout.nix
    ../../homeModules/notification.nix
    ../../homeModules/light.nix
  # Terminal & Shell
    ../../homeModules/terminal.nix
    ../../homeModules/shell.nix
  # Networking
    ../../homeModules/ssh.nix
    ../../homeModules/kdeconnect.nix
  # Development
    ../../homeModules/git.nix
    ../../homeModules/vscode.nix
    ../../homeModules/tex.nix
  # Media & Files
    ../../homeModules/xdg.nix
    ../../homeModules/mpv.nix
    ../../homeModules/qimgv.nix
    ../../homeModules/lf.nix
    ../../homeModules/capture.nix  
  # Applications
    ../../homeModules/floorp.nix
    #../../homeModules/firefox.nix
    #../../homeModules/libreoffice.nix
    ../../homeModules/onlyoffice.nix
  ];

  programs.home-manager.enable = true; 
  home.username = config.user;
  home.homeDirectory = "/home/${config.user}";
  home.stateVersion = config.stateVersion;
  nixpkgs.config.allowUnfreePredicate = _: true;
 
  # Debug
  #stylix.enable = lib.mkForce true;

  # Host specific settings
  programs.yt-dlp.enable = true;
  home.packages = with pkgs; [
    #rustdesk
    vesktop # discord
    gnome-calculator
    nextcloud-client
    obsidian
    ffmpeg-full
    picard
    
    # dev
    gcc
    gdb
    powershell
  ];
}
