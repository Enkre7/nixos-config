{ config, lib, pkgs, ... }:

let
  c = config.lib.stylix.colors;
  hasFingerprint = config.isLaptop;

  placeholderText =
    if hasFingerprint then "<i>Password or fingerprint</i>" else "<i>Password</i>";

  instructionText =
    if hasFingerprint
    then "Enter your password or use fingerprint"
    else "Enter your password";

  batteryLabel = lib.optionalString hasFingerprint ''
    label {
      monitor =
      text = cmd[update:30000] echo " $(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -1 || echo "?")%"
      color = rgb(${c.base0C})
      font_size = 14
      font_family = JetBrains Mono Nerd Font
      position = 30, -30
      halign = left
      valign = bottom
    }
  '';
in
{
  home.packages = [ pkgs.hyprlock ];

  xdg.configFile."hypr/hyprlock.conf".text = ''
    general {
      disable_loading_bar = true
      grace = 2
      hide_cursor = true
      no_fade_in = false
      no_fade_out = false
      ignore_empty_input = false
      immediate_render = true
    }

    auth {
      pam:enabled = true
      pam:module = hyprlock
      fingerprint:enabled = ${if hasFingerprint then "true" else "false"}
    }

    background {
      monitor =
      path = ${toString config.wallpaper}
      color = rgb(${c.base00})
      blur_size = 6
      blur_passes = 2
      noise = 0.0
      contrast = 1.1
      brightness = 0.7
      vibrancy = 0.15
      vibrancy_darkness = 0.0
    }

    input-field {
      monitor =
      size = 340, 60
      outline_thickness = 3
      dots_size = 0.30
      dots_spacing = 0.35
      dots_center = true
      dots_rounding = -1
      outer_color = rgb(${c.base0D})
      inner_color = rgb(${c.base00})
      font_color = rgb(${c.base05})
      check_color = rgb(${c.base0B})
      fail_color = rgb(${c.base08})
      capslock_color = rgb(${c.base09})
      fade_on_empty = true
      fade_timeout = 2000
      placeholder_text = ${placeholderText}
      hide_input = false
      rounding = 15
      position = 0, -200
      halign = center
      valign = center
    }

    label {
      monitor =
      text = cmd[update:1000] echo "<span font='72'><b>$(date '+%H:%M')</b></span>"
      color = rgb(${c.base05})
      font_size = 72
      font_family = JetBrains Mono Nerd Font
      position = 0, 250
      halign = center
      valign = center
      shadow_passes = 2
      shadow_size = 3
      shadow_color = rgb(${c.base00})
    }

    label {
      monitor =
      text = cmd[update:3600000] echo "<span font='20'>$(date '+%A %d %B %Y' | tr '[:lower:]' '[:upper:]')</span>"
      color = rgb(${c.base00})
      font_size = 20
      font_family = JetBrains Mono Nerd Font
      position = 0, 180
      halign = center
      valign = center
    }

    label {
      monitor =
      text = ${instructionText}
      color = rgb(${c.base01})
      font_size = 14
      font_family = JetBrains Mono Nerd Font
      position = 0, -120
      halign = center
      valign = center
    }

    label {
      monitor =
      text = ${config.hostname}
      color = rgb(${c.base05})
      font_size = 16
      font_family = JetBrains Mono Nerd Font
      position = -40, -40
      halign = right
      valign = bottom
    }

    ${batteryLabel}
  '';
}
