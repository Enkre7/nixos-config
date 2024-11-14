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
    ../../homeModules/firefox.nix
    ../../homeModules/git.nix
    ../../homeModules/vscode.nix
    ../../homeModules/shell.nix
    ../../homeModules/terminal.nix
    ../../homeModules/kdeconnect.nix
    ../../homeModules/wofi.nix
    ../../homeModules/libreoffice.nix
  ];

  programs.home-manager.enable = true; 
  home.username = config.user;
  home.homeDirectory = "/home/${config.user}";
  home.stateVersion = config.stateVersion;
  nixpkgs.config.allowUnfreePredicate = _: true;

  # Host specific settings
  programs.mpv = {
      enable = true;
      scripts = [pkgs.mpvScripts.mpris];
    };

  programs.yt-dlp.enable = true;
  home.packages = with pkgs; [
    vesktop # discord
    gnome-calculator
    nextcloud-client
    obsidian    
    qimgv
    ffmpeg-full
    picard
    
    # dev
    gcc
    gdb
    powershell
  ];
}
