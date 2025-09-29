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
    #../../homeModules/sway.nix
    #../../homeModules/niri.nix
    ../../homeModules/waybar.nix
    ../../homeModules/wofi.nix
    ../../homeModules/wlogout.nix
    ../../homeModules/swaync.nix
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
    #../../homeModules/tex.nix
  # Media & Files
    ../../homeModules/xdg.nix
    ../../homeModules/mpv.nix
    ../../homeModules/qimgv.nix
    ../../homeModules/lf.nix
    ../../homeModules/capture.nix  
  # Applications
    ../../homeModules/nextcloud-client.nix
    #../../homeModules/floorp.nix
    ../../homeModules/firefox.nix
    #../../homeModules/chromium.nix
    #../../homeModules/libreoffice.nix
    ../../homeModules/onlyoffice.nix
    #../../homeModules/minecraft.nix
    #../../homeModules/lutris.nix
  ];

  programs.home-manager.enable = true; 
  home.username = config.user;
  home.homeDirectory = "/home/${config.user}";
  home.stateVersion = config.stateVersion;
  nixpkgs.config.allowUnfreePredicate = _: true;
 
  # Debug
  #stylix.enable = lib.mkForce true;

  wayland.windowManager.hyprland.settings = {
    monitor = lib.mkForce "eDP-1,highrr,auto,1.6";
  };
   
  xdg.configFile."niri/config.kdl".text = lib.mkAfter ''
    output "eDP-1" {
      scale 1.6
    }
  '';
   
  # Host specific settings
  programs.yt-dlp.enable = true;
  home.packages = with pkgs; [
    #rustdesk
    prusa-slicer
    drawio
    vesktop # discord
    gnome-calculator
    obsidian
    ffmpeg-full
    picard
    powershell
  ];
}
