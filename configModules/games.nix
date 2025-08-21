{ pkgs, ... }: 
{
  # Steam
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.steam.remotePlay.openFirewall = true;
  programs.steam.dedicatedServer.openFirewall = true;
  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    steam-run
    steam
    #heroic
    protonup
    winetricks
    (wineWowPackages.waylandFull.override {
      wineRelease = "staging";
      mingwSupport = true;
    })
    pavucontrol
    playerctl
    mangohud
    cockatrice
  ];

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS =
      "\${HOME}/.steam/root/compatibilitytools.d";
  };
}
