{ pkgs, config, ... }:

let
  stylix = config.lib.stylix.colors;
in
{
  home.packages = with pkgs; [ imv ];

  xdg.configFile."imv/config" = {
    text = ''
      [options]
      background = ${stylix.base00}
      overlay_background_color = ${stylix.base01}
      overlay_background_alpha = 88
      overlay_text_color = ${stylix.base05}
      fullscreen = false
      width = 1200
      height = 800
      initial_pan = 0.5,0.5
      overlay_font = JetBrainsMono Nerd Font Mono:12
      overlay_text = $imv_current_file [$imv_current_index/$imv_file_count] [$imv_width x $imv_height] $imv_scale%
      zoom_speed = 20
      scaling_mode = shrink
      upscaling_method = lanczos
      background_pattern = checkerboard
      slideshow_duration = 5
      cache_size = 512
      preload_neighbours = true

      [aliases]
      q = quit
      x = close

      [binds]
      <Left> = prev
      <Right> = next
      <Space> = next
      <BackSpace> = prev
      g = goto 1
      <Shift+G> = goto -1
      j = zoom -1
      k = zoom 1
      <Ctrl+0> = zoom actual
      h = pan 50 0
      l = pan -50 0
      f = fullscreen
      c = center
      s = scaling next
      a = zoom actual
      <Return> = zoom optimal
      r = rotate by 90
      <Shift+R> = rotate by -90
      d = exec rm "$imv_current_file"; close
      y = exec echo -n "$imv_current_file" | wl-copy
      e = exec thunar "$(dirname "$imv_current_file")"
      i = overlay
      <F1> = exec notify-send "imv" "←/→: navigation, j/k: zoom, f: plein écran, q: quitter"
      q = quit
      <Escape> = quit
    '';
    force = false;
  };

  xdg.mimeApps.defaultApplications = {
    "image/jpeg" = "imv.desktop";
    "image/png" = "imv.desktop";
    "image/gif" = "imv.desktop";
    "image/webp" = "imv.desktop";
    "image/svg+xml" = "imv.desktop";
    "image/bmp" = "imv.desktop";
    "image/tiff" = "imv.desktop";
    "image/avif" = "imv.desktop";
    "image/heic" = "imv.desktop";
  };
}
