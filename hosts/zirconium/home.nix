{ config, pkgs, lib, inputs, vars, ... }:

{
  imports = [
    ./variables.nix
    ../../homeModules/stylix.nix
    #../../homeModules/impermanence.nix
    ../../homeModules/wlogout.nix
    ../../homeModules/waybar.nix
    ../../homeModules/light.nix
    ../../homeModules/notification.nix
    ../../homeModules/capture.nix
    ../../homeModules/hyprland.nix
    ../../homeModules/hyprlock.nix
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
  #stylix.enable = lib.mkForce false;

  # Host specific settings
  wayland.windowManager.hyprland.settings = {
    monitor = lib.mkForce ",4096x2160@119.88,0x0,1.333333";
    general.gaps_in = lib.mkForce 4;
    general.gaps_out = lib.mkForce 7;
  }; 
  
  xsession.numlock.enable = true;

  home.packages = with pkgs; [
    rustdesk
    vesktop # discord
    r2modman
    obsidian
    gnome-calculator
    nextcloud-client
    ffmpeg-full
  ];
}
