{ config, pkgs, ... }:

{
   stylix = {
    enable = true;
    autoEnable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${config.styleTheme}.yaml";
    image = pkgs.runCommand "wallpaper.png" {} ''
      cp ${config.wallpaper} $out
    '';
    polarity = config.stylePolarity;
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 26;
    };
    fonts = {
      monospace.package = pkgs.nerd-fonts.jetbrains-mono;
      monospace.name = "JetbrainsMono Nerd Font Propo";
      sansSerif.package = pkgs.dejavu_fonts;
      sansSerif.name = "DejaVu Sans";
      serif.package = pkgs.dejavu_fonts;
      serif.name = "DejaVu Serif";
    };
    opacity = {
      applications = 1.0;
      terminal = 0.7;
      desktop = 1.0;
      popups = 0.7;
    };
  };

  environment.systemPackages = with pkgs; [
    swww
    hyprcursor
    papirus-icon-theme
    adwaita-icon-theme
  ];
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = 1;
    HYPRCURSOR_THEME = "Bibata-Modern-Ice";
    HYPRCURSOR_SIZE = 56;
  }; 
}
