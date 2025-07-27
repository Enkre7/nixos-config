{ config, lib, ... }:

let
  stylix = config.lib.stylix.colors.withHashtag;
  hasFingerprint = config.isLaptop;
  
  placeholderText = if hasFingerprint 
    then ''<i>Password or fingerprint</i>''
    else ''<i>Password</i>'';
    
  instructionText = if hasFingerprint
    then "Enter your password or use fingerprint"
    else "Enter your password";
in
{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 2;
        hide_cursor = true;
        no_fade_in = false;
        no_fade_out = false;
        ignore_empty_input = false;
        immediate_render = true;
        pam_module = "hyprlock";
      };

      background = [
        {
          monitor = "";
          path = config.wallpaper;
          color = stylix.base00;
          blur_size = 6;
          blur_passes = 2;
          noise = 0.0;
          contrast = 1.1;
          brightness = 0.7;
          vibrancy = 0.15;
          vibrancy_darkness = 0.0;
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "340, 60";
          outline_thickness = 3;
          dots_size = 0.30;
          dots_spacing = 0.35;
          dots_center = true;
          dots_rounding = -1;
          
          outer_color = stylix.base0D;
          inner_color = stylix.base00;
          font_color = stylix.base05;
          check_color = stylix.base0B;
          fail_color = stylix.base08;
          capslock_color = stylix.base09;
          
          fade_on_empty = true;
          fade_timeout = 2000;
          placeholder_text = placeholderText;
          hide_input = false;
          rounding = 15;
          
          position = "0, -200";
          halign = "center";
          valign = "center";
        }
      ];

      label = [
        # Clock
        {
          monitor = "";
          text = ''cmd[update:1000] echo "<span font='72'><b>$(date '+%H:%M')</b></span>"'';
          color = stylix.base05;
          font_size = 72;
          font_family = "JetBrains Mono Nerd Font";
          position = "0, 250";
          halign = "center";
          valign = "center";
          shadow_passes = 2;
          shadow_size = 3;
          shadow_color = stylix.base00;
        }

        # Date
        {
          monitor = "";
          text = ''cmd[update:3600000] echo "<span font='20'>$(date '+%A %d %B %Y' | tr '[:lower:]' '[:upper:]')</span>"'';
          color = stylix.base05;
          font_size = 20;
          font_family = "JetBrains Mono Nerd Font";
          position = "0, 180";
          halign = "center";
          valign = "center";
        }

        # Instructions
        {
          monitor = "";
          text = instructionText;
          color = stylix.base04;
          font_size = 14;
          font_family = "JetBrains Mono Nerd Font";
          position = "0, -120";
          halign = "center";
          valign = "center";
        }

        # Hostname
        {
          monitor = "";
          text = "${config.hostname}";
          color = stylix.base05;
          font_size = 16;
          font_family = "JetBrains Mono Nerd Font";
          position = "-40, -40";
          halign = "right";
          valign = "bottom";
        }
      ] ++ lib.optionals config.isLaptop [
        # Battery
        {
          monitor = "";
          text = ''cmd[update:30000] echo " $(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -1 || echo "?")%"'';
          color = stylix.base0C;
          font_size = 14;
          font_family = "JetBrains Mono Nerd Font";
          position = "30, -30";
          halign = "left";
          valign = "bottom";
        }
      ];
    };
  };
}
