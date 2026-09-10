{ config, pkgs, lib, inputs, vars, ... }:

{
  imports = [
  # Core
    ./variables.nix
    ../../homeModules/stylix.nix
    #../../homeModules/impermanence.nix
    ../../homeModules/nix-index.nix  
  # Desktop Environment
    #noctalia ../../homeModules/hyprland.nix
    ../../homeModules/hyprland-noctalia.nix
    ../../homeModules/noctalia.nix
    #../../homeModules/sway.nix
    #../../homeModules/niri.nix
    #noctalia ../../homeModules/hyprlock.nix
    #noctalia ../../homeModules/swayidle.nix
    #noctalia ../../homeModules/waybar2.nix
    #../../homeModules/wofi.nix
    #../../homeModules/wlogout.nix
    #noctalia ../../homeModules/rofi.nix
    #noctalia ../../homeModules/swaync.nix
    #noctalia ../../homeModules/light.nix
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
    ../../homeModules/file-templates.nix
    ../../homeModules/mpv.nix
    ../../homeModules/qimgv.nix
    ../../homeModules/lf.nix
    ../../homeModules/capture.nix  
  # Applications
    ../../homeModules/nextcloud-client.nix
    #../../homeModules/floorp.nix
    ../../homeModules/firefox.nix
    ../../homeModules/chromium.nix
    #../../homeModules/libreoffice.nix
    ../../homeModules/onlyoffice.nix
    ../../homeModules/minecraft.nix
    #../../homeModules/lutris.nix
    ../../homeModules/packettracer.nix
  ];

  programs.home-manager.enable = true; 
  home.username = config.user;
  home.homeDirectory = "/home/${config.user}";
  home.stateVersion = config.stateVersion;
  nixpkgs.config.allowUnfreePredicate = _: true;
 
  # Debug
  #stylix.enable = lib.mkForce true;
  nixpkgs.config.permittedInsecurePackages = [
    "pnpm-10.29.2"
  ];

  wayland.windowManager.hyprland.settings.monitor = lib.mkForce [
    { output = "eDP-1"; mode = "highrr"; position = "0x0"; scale = 1.6; }
    { output = "DP-1"; mode = "preferred"; position = "auto"; scale = 1.0; }
    { output = "DP-2"; mode = "preferred"; position = "auto"; scale = 1.0; }
    { output = "DP-3"; mode = "preferred"; position = "auto"; scale = 1.0; }
    { output = "DP-4"; mode = "preferred"; position = "auto"; scale = 1.0; }
  ];
   
  # Host specific settings
  programs.yt-dlp.enable = true;
  home.packages = with pkgs; [
    prusa-slicer
    drawio
    vesktop # discord
    gnome-calculator
    obsidian
    #lmstudio
    plex-desktop
    #ffmpeg-full
    #picard
    #powershell
  ];
}
