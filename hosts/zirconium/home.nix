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
    #../../homeModules/mako.nix
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
    ../../homeModules/floorp.nix
    #../../homeModules/chromium.nix
    #../../homeModules/libreoffice.nix
    ../../homeModules/onlyoffice.nix
  ];
  
  programs.home-manager.enable = true;
  home.username = config.user;
  home.homeDirectory = "/home/${config.user}";
  home.stateVersion = config.stateVersion;
  nixpkgs.config.allowUnfreePredicate = _: true;  

  # Debug
  #stylix.enable = lib.mkForce false;

  # Host specific settings
  wayland.windowManager.hyprland.settings = {
    #monitor = lib.mkForce ",4096x2160@119.88,0x0,1.333333";
    monitor = lib.mkForce ",preferred,auto,1.333333";
    general.gaps_in = lib.mkForce 4;
    general.gaps_out = lib.mkForce 7;
  }; 
  
  xsession.numlock.enable = true;

  home.packages = with pkgs; [
    drawio
    rustdesk
    vesktop # discord
    r2modman
    obsidian
    gnome-calculator
    ffmpeg-full
  ];
}
