{ pkgs, ... }: 
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
    #heroic
    protonup
    (prismlauncher.override { # Minecraft
      # Add binary required by some mod
      additionalPrograms = [ ffmpeg ];
      # Change Java runtimes available to Prism Launcher
      jdks = [
        temurin-jre-bin-8
        temurin-jre-bin-17
        graalvm-ce
        zulu8
        zulu17
        zulu
      ];
    })
    (wineWowPackages.full.override {
      wineRelease = "staging";
      mingwSupport = true;
     })
    winetricks
    pavucontrol
    playerctl
    mangohud    
    bottles
    cockatrice
  ];

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS =
      "\${HOME}/.steam/root/compatibilitytools.d";
  };
}
