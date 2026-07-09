{ inputs, lib, ... }:

{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia = {
    enable = true;
    systemd.enable = true;

    settings = {
      bar = {
        order = [ "widgets" ];
        widgets = {
          position = "top";
          thickness = 32;
          scale = 1.1;
          margin_edge = 6;
          margin_ends = 119;
          margin_opposite_edge = 7;
          widget_spacing = 5;
          start = [ "control-center" "session" "launcher" "clipboard" "notes" "workspaces" ];
          center = [ "date" "clock" ];
          end = [ "media" "tray" "volume" "notifications" "network" "bluetooth" "battery" ];
        };
      };

      brightness.sync_all_monitors = true;

      calendar.enabled = true;

      desktop_widgets = {
        schema_version = 2;
        widget_order = [
          "desktop-widget-0000000000000001"
          "desktop-widget-0000000000000002"
          "desktop-widget-0000000000000004"
        ];
        grid = {
          cell_size = 16;
          major_interval = 4;
          visible = true;
        };
        widget."desktop-widget-0000000000000001" = {
          box_height = 112.0;
          box_width = 208.0;
          cx = 705.0;
          cy = 470.0;
          output = "eDP-1";
          rotation = 0.0;
          type = "clock";
          settings = {
            background = false;
            background_color = "on_surface_variant";
            background_opacity = 0.0;
            background_padding = 0;
            background_radius = 0;
            center_text = false;
            clock_style = "digital";
            format = "{:%H:%M}";
            shadow = false;
          };
        };
        widget."desktop-widget-0000000000000002" = {
          box_height = 32.0;
          box_width = 48.0;
          cx = 1377.0;
          cy = 22.0;
          output = "eDP-1";
          rotation = 0.0;
          type = "sysmon";
          settings = {
            background = false;
            background_opacity = 0.52;
            color = "on_surface";
            display = "gauge";
            gauge_layout = "horizontal";
            label_min_width = 0;
            stat = "cpu_usage";
            stat2 = "cpu_temp";
          };
        };
        widget."desktop-widget-0000000000000004" = {
          box_height = 32.0;
          box_width = 48.0;
          cx = 1321.0;
          cy = 22.0;
          output = "eDP-1";
          rotation = 0.0;
          type = "sysmon";
          settings = {
            background = false;
            background_opacity = 0.52;
            color = "on_surface";
            display = "gauge";
            gauge_layout = "horizontal";
            label_min_width = 0;
            stat = "ram_pct";
            stat2 = "cpu_temp";
          };
        };
      };

      dock = {
        auto_hide = true;
        enabled = true;
        icon_size = 32;
        launcher_position = "start";
        pinned = [ "Firefox" "Steam" "VSCodium" "Kitty" ];
        reserve_space = false;
        show_dots = true;
      };

      idle = {
        behavior_order = [ "lock" "screen-off" "lock-and-suspend" ];
        behavior = {
          lock = { action = "lock"; enabled = true; timeout = 600.0; };
          "screen-off" = { action = "screen_off"; enabled = true; timeout = 660.0; };
          "lock-and-suspend" = { action = "lock_and_suspend"; enabled = true; timeout = 900.0; };
        };
      };

      location = {
        auto_locate = false;
        latitude = 45.7640;
        longitude = 4.8357;
      };

      lockscreen.blurred_desktop = true;

      lockscreen_widgets = {
        enabled = true;
        schema_version = 2;
        widget_order = [
          "lockscreen-login-box@eDP-1"
          "lockscreen-widget-0000000000000001"
          "lockscreen-widget-0000000000000002"
        ];
        widget."lockscreen-login-box@eDP-1" = {
          box_height = 70.0;
          box_width = 400.0;
          cx = 705.0;
          cy = 547.0;
          output = "eDP-1";
          rotation = 0.0;
          type = "login_box";
          settings = {
            background_color = "surface_variant";
            background_opacity = 0.61;
            background_radius = 32.0;
            input_opacity = 1.0;
            input_radius = 32.0;
            show_caps_lock = true;
            show_keyboard_layout = true;
            show_login_button = true;
            show_password_hint = true;
          };
        };
        widget."lockscreen-widget-0000000000000001" = {
          box_height = 192.0;
          box_width = 416.0;
          cx = 705.0;
          cy = 310.0;
          output = "eDP-1";
          rotation = 0.0;
          type = "clock";
          settings = {
            background = false;
            center_text = false;
            clock_style = "digital";
            format = "{:%H:%M}";
            shadow = false;
          };
        };
        widget."lockscreen-widget-0000000000000002" = {
          box_height = 48.0;
          box_width = 112.0;
          cx = 705.0;
          cy = 390.0;
          output = "eDP-1";
          rotation = 0.0;
          type = "weather";
          settings = {
            background = false;
            shadow = false;
          };
        };
      };

      nightlight.enabled = true;

      plugins.enabled = [ "noctalia/notes" ];

      shell = {
        avatar_path = "/home/enkre/Nextcloud/MEDIAS/Famille memoji/victor_memoji.png";
        font_family = lib.mkForce "JetBrainsMono Nerd Font Propo";
        launch_apps_as_systemd_services = true;
        polkit_agent = true;
        screen_time_enabled = true;
        panel.transparency_mode = "soft";
        screen_corners.size = 41;
      };

      widget = {
        media = {
          hide_when_no_media = true;
          scale = 0.9;
        };
        network.show_label = false;
        tray = { drawer = true; hidden = [ "Blueman" "Réseau" ]; };
        volume.show_label = false;
        notes.type = "noctalia/notes:notes";
      };
    };
  };
}
