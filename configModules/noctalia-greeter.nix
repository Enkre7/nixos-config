{ config, ... }:
let
  colors = config.lib.stylix.colors.withHashtag;
in
{
  services.displayManager.noctalia-greeter = {
    enable = true;
    cursorTheme = {
      inherit (config.stylix.cursor) package name;
    };
    settings = {
      session.default = "Hyprland (UWSM)";
      user.default = config.user;
      keyboard.layout = "fr";
      appearance = {
        scheme = "Synced";
        theme_mode = config.stylePolarity;
        font_family = "JetBrainsMono Nerd Font Propo";
        wallpaper = {
          path = "${config.stylix.image}";
          fill_mode = "crop";
        };
        palette = with colors; {
          primary = base0D;
          on_primary = base00;
          secondary = base0E;
          on_secondary = base00;
          tertiary = base0C;
          on_tertiary = base00;
          error = base08;
          on_error = base00;
          surface = base00;
          on_surface = base05;
          surface_variant = base01;
          on_surface_variant = base04;
          outline = base03;
          shadow = base00;
          hover = base0C;
          on_hover = base00;
        };
      };
    };
  };

  security.polkit.enablePkexecWrapper = false;
}
