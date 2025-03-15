{ config, pkgs, lib, inputs, vars, ... }:

{
  imports = [
    ./variables.nix
    ../../homeModules/stylix.nix
    #../../homeModules/impermanence.nix
    ../../homeModules/wlogout.nix
    ../../homeModules/waybar.nix
    ../../homeModules/light.nix
    ../../homeModules/nix-index.nix
    ../../homeModules/notification.nix
    ../../homeModules/capture.nix
    ../../homeModules/hyprland.nix
    ../../homeModules/hyprlock.nix
    #../../homeModules/hypridle.nix
    ../../homeModules/floorp.nix
    #../../homeModules/firefox.nix
    ../../homeModules/git.nix
    ../../homeModules/mpv.nix
    ../../homeModules/qimgv.nix
    ../../homeModules/vscode.nix
    ../../homeModules/tex.nix
    ../../homeModules/shell.nix
    ../../homeModules/terminal.nix
    ../../homeModules/kdeconnect.nix
    ../../homeModules/wofi.nix
    #../../homeModules/libreoffice.nix
    ../../homeModules/onlyoffice.nix
    ../../homeModules/lf.nix
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
    rustdesk
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
