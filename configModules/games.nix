{ config, pkgs, ... }: 
{
  # Minecraft
  programs.java.enable = true;

  # Steam
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.steam.remotePlay.openFirewall = true;
  programs.steam.dedicatedServer.openFirewall = true;
  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    steam-run
    steam
    lutris
    heroic
    protonup
    prismlauncher # Minecraft
    pavucontrol
    playerctl
    mangohud    
  ];
}