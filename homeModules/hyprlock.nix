{config, ...}:

let
  stylix = config.lib.stylix.colors.withHashtag;
in
{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = [
        {
          hide_cursor = true;
          immediate_render = true;
        }
      ];

      background = [
        {
          monitor = "";
          path = config.wallpaper;
          color = "${stylix.base01}";
          blur_size = 4;
          blur_passes = 3;
          noise = 0.0117;
          contrast = 1.3000;
          brightness = 0.8000;
          vibrancy = 0.2100;
          vibrancy_darkness = 0.0;
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "250, 50";
          outline_thickness = 2;
          dots_size = 0.26; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.64; # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true;
          outer_color = "${stylix.base0D}";
          inner_color = "${stylix.base0D}";
          font_color = "${stylix.base05}";
          check_color = "${stylix.base04}";
          fail_color = "${stylix.base08}";
          fade_on_empty = true;
          placeholder_text = ''<i>Authentification...</i>'';
          position = "0, 50";
          halign = "center";
          valign = "bottom";
        }
      ];

      label = [
        # Current time
        {
          monitor = "";
          text = ''cmd[update:1000] echo "<b><big> $(date "+%H:%M:%S") </big></b>"'';
          color = "${stylix.base04}";
          font_size = 64;
          font_family = "JetBrains Mono Nerd Font 10";
          shadow_passes = 3;
          shadow_size = 4;
          position = "0, 55";
          halign = "center";
          valign = "center";
        }

        # Date
        {
          monitor = "";
          text = ''cmd[update:18000000] echo "<b> "$(date '+%A, %-d %B %Y')" </b>"'';
          color = "${stylix.base04}";
          font_size = 24;
          font_family = "JetBrains Mono Nerd Font 10";
          position = "0, -16";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
