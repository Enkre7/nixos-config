{ pkgs, ... }: 
{
  programs.java.enable = true;

  home.packages = with pkgs; [
    (prismlauncher.override {
      additionalPrograms = [ ffmpeg ];
      jdks = [
        temurin-jre-bin-8
        temurin-jre-bin-17
        graalvm-ce
        zulu8
        zulu17
        zulu
      ];
    })
  ];
}
