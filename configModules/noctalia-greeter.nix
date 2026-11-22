{ config, lib, ... }:
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
      auth = {
        allow_empty_password = true;
        request_timeout = 0;
      };
      appearance = {
        scheme = "Synced";
        theme_mode = config.stylePolarity;
        font_family = "JetBrainsMono Nerd Font Propo";
        wallpaper = {
          path = "${config.stylix.image}";
          fill_mode = "crop";
          blur = 0.5;
          tint = 0.3;
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

  security.pam.services.greetd.rules.auth = lib.mkIf config.security.pam.services.greetd.fprintAuth {
    fprintd = {
      order = 10000;
      settings = {
        timeout = 10;
        max-tries = 2;
      };
    };
  };
}
