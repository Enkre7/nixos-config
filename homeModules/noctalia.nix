{ config, inputs, lib, ... }:

let
  groupNotes = {
    accordion = false;
    accordion_direction = "end";
    enabled = true;
    fill = "surface_variant";
    id = "g1";
    members = [ "notes" "clipboard" ];
    opacity = 1.0;
    padding = 6.0;
  };

  groupNetwork = {
    accordion = false;
    accordion_direction = "end";
    enabled = true;
    fill = "surface_variant";
    id = "g2";
    members = [ "network" "bar_3" "bluetooth" ];
    opacity = 1.0;
    padding = 6.0;
  };

  groupVolume = {
    accordion = false;
    accordion_direction = "end";
    enabled = true;
    fill = "surface_variant";
    id = "g3";
    members = [ "volume" "notifications" ];
    opacity = 1.0;
    padding = 6.0;
  };

  topBarBase = {
    center = [ "date" "clock" ];
    concave_edge_corners = true;
    margin_edge = 6;
    margin_ends = 119;
    margin_opposite_edge = 7;
    padding = 14;
    scale = 1.1;
    start = [ "control-center" "spacer_2" "workspaces" ];
    thickness = 32;
    widget_spacing = 5;
  };

  monitorBar = topBarBase // {
    end = [ "media" "group:g1" "tray" "group:g3" "group:g2" "battery" ];
    capsule_group = [ groupNotes groupNetwork groupVolume ];
  };

  sideBarBase = {
    enabled = true;
    concave_edge_corners = true;
    font_family = "JetBrainsMono Nerd Font Propo";
    font_weight = 500;
    margin_edge = 9;
    margin_opposite_edge = 0;
    padding = 14;
    reserve_space = false;
    smart_auto_hide = false;
    thickness = 68;
    widget_spacing = 6;
    start = [ ];
    center = [ "clipboard" "screenshot" "ocr" "bar" "status" ];
    end = [ ];
  };

  externalOutputs = [ "DP-1" "DP-2" "DP-3" "DP-4" ];

  externalBar = output: {
    name = output;
    value = monitorBar // {
      match = output;
      reserve_space = false;
      smart_auto_hide = true;
    };
  };
in
{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia = {
    enable = true;
    systemd.enable = true;

    settings = {
      bar = {
        order = [ "widgets" "side" ];

        widgets = topBarBase // {
          position = "top";
          font_weight = 500;
          reserve_space = true;
          smart_auto_hide = false;
          end = [ "media" "tray" "group:g3" "group:g2" "battery" ];
          capsule_group = [ groupNetwork groupVolume ];
          monitor =
            (builtins.listToAttrs (map externalBar externalOutputs))
            // {
              "eDP-1" = monitorBar // {
                match = "eDP-1";
                reserve_space = true;
                smart_auto_hide = false;
              };
              "HDMI-A-1" = topBarBase // {
                match = "HDMI-A-1";
                end = [ "media" "tray" "group:g3" "group:g2" "battery" ];
                capsule_group = [ groupNetwork groupVolume ];
                margin_edge = 10;
                margin_ends = 263;
                scale = 1.2;
                reserve_space = true;
                smart_auto_hide = false;
              };
            };
        };

        side = sideBarBase // {
          position = "left";
          auto_hide = true;
          margin_ends = 350;
          scale = 1.0;
          monitor."HDMI-A-1" = sideBarBase // {
            match = "HDMI-A-1";
            auto_hide = true;
            margin_ends = 526;
            scale = 1.05;
          };
        };
      };

      brightness.sync_all_monitors = true;

      calendar = {
        enabled = true;
        event_date_format = "%A %e %B";
        event_time_format = "%H:%M";
        refresh_minutes = 15;
        account.subscription = {
          name = "Proton";
          type = "ics";
          server_url = config.protonCalendarUrl;
        };
        reminders = {
          enabled = true;
          all_day_digest_time = "09:00";
          default_lead_minutes = 10;
          use_event_reminders = true;
        };
      };

      control_center = {
        show_session_button = true;
        show_shortcut_labels = true;
        sidebar = "compact";
        sidebar_section = "compact";
        width = 700;
        calendar = {
          show_events_card = true;
          show_week_numbers = false;
        };
        shortcuts = [
          { type = "wifi"; }
          { type = "bluetooth"; }
          { type = "caffeine"; }
          { type = "nightlight"; }
          { type = "notification"; }
          { type = "power_profile"; }
        ];
      };

      desktop_widgets = {
        enabled = true;
        schema_version = 2;
        widget_order = [
          "desktop-widget-0000000000000001"
          "desktop-widget-0000000000000002"
          "desktop-widget-0000000000000004"
          "desktop-widget-0000000000000005"
          "desktop-widget-0000000000000006"
          "desktop-widget-0000000000000007"
        ];
        grid = {
          cell_size = 8;
          major_interval = 4;
          visible = true;
        };
        widget."desktop-widget-0000000000000001" = {
          box_height = 112.0;
          box_width = 208.0;
          cx = 705.0;
          cy = 470.0;
          enabled = true;
          output = "eDP-1";
          placement_height = 940.0;
          placement_width = 1410.0;
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
          cx = 737.0;
          cy = 526.0;
          enabled = true;
          output = "eDP-1";
          placement_height = 940.0;
          placement_width = 1410.0;
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
          cx = 673.0;
          cy = 526.0;
          enabled = true;
          output = "eDP-1";
          placement_height = 940.0;
          placement_width = 1410.0;
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
        widget."desktop-widget-0000000000000005" = {
          box_height = 112.0;
          box_width = 208.0;
          cx = 960.0;
          cy = 540.0;
          enabled = true;
          output = "DP-3";
          placement_height = 1080.0;
          placement_width = 1920.0;
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
        widget."desktop-widget-0000000000000006" = {
          box_height = 32.0;
          box_width = 48.0;
          cx = 928.0;
          cy = 596.0;
          enabled = true;
          output = "DP-3";
          placement_height = 1080.0;
          placement_width = 1920.0;
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
        widget."desktop-widget-0000000000000007" = {
          box_height = 32.0;
          box_width = 48.0;
          cx = 992.0;
          cy = 596.0;
          enabled = true;
          output = "DP-3";
          placement_height = 1080.0;
          placement_width = 1920.0;
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
      };

      dock = {
        auto_hide = true;
        enabled = false;
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

      lockscreen = {
        blurred_desktop = true;
        fingerprint = true;
        lock_before_suspend = true;
      };

      lockscreen_widgets = {
        enabled = true;
        schema_version = 2;
        widget_order = [
          "lockscreen-login-box@FALLBACK"
          "lockscreen-login-box@HDMI-A-1"
          "lockscreen-login-box@DP-4"
          "lockscreen-login-box@DP-2"
          "lockscreen-login-box@DP-3"
          "lockscreen-login-box@eDP-1"
          "lockscreen-widget-0000000000000001"
          "lockscreen-widget-0000000000000002"
          "lockscreen-widget-0000000000000003"
          "lockscreen-widget-0000000000000008"
        ];
        grid = {
          cell_size = 16;
          major_interval = 4;
          visible = true;
        };
        widget."lockscreen-login-box@FALLBACK" = {
          box_height = 196.0;
          box_width = 810.0;
          cx = 960.0;
          cy = 898.0;
          enabled = true;
          output = "FALLBACK";
          placement_height = 1080.0;
          placement_width = 1920.0;
          rotation = 0.0;
          type = "login_box";
          settings = {
            background_color = "surface_variant";
            background_opacity = 0.88;
            background_radius = 12.0;
            center_password_text = false;
            input_opacity = 1.0;
            input_radius = 6.0;
            layout = "regular";
            show_caps_lock = true;
            show_keyboard_layout = true;
            show_login_button = true;
            show_media = true;
            show_session_buttons = true;
            show_unlock_hint = true;
            show_weather = true;
          };
        };
        widget."lockscreen-login-box@HDMI-A-1" = {
          box_height = 70.0;
          box_width = 400.0;
          cx = 1152.0;
          cy = 683.0;
          enabled = true;
          output = "HDMI-A-1";
          placement_height = 1296.0;
          placement_width = 2304.0;
          rotation = 0.0;
          type = "login_box";
          settings = {
            background_color = "surface_variant";
            background_opacity = 0.88;
            background_radius = 32.0;
            center_password_text = false;
            input_opacity = 1.0;
            input_radius = 32.0;
            layout = "compact";
            show_caps_lock = true;
            show_keyboard_layout = true;
            show_login_button = true;
            show_media = true;
            show_session_buttons = true;
            show_unlock_hint = true;
            show_weather = true;
          };
        };
        widget."lockscreen-login-box@DP-2" = {
          box_height = 196.0;
          box_width = 810.0;
          cx = 960.0;
          cy = 898.0;
          enabled = true;
          output = "DP-2";
          placement_height = 1080.0;
          placement_width = 1920.0;
          rotation = 0.0;
          type = "login_box";
          settings = {
            background_color = "surface_variant";
            background_opacity = 0.88;
            background_radius = 12.0;
            center_password_text = false;
            input_opacity = 1.0;
            input_radius = 6.0;
            layout = "regular";
            show_caps_lock = true;
            show_keyboard_layout = true;
            show_login_button = true;
            show_media = true;
            show_session_buttons = true;
            show_unlock_hint = true;
            show_weather = true;
          };
        };
        widget."lockscreen-login-box@DP-3" = {
          box_height = 70.0;
          box_width = 400.0;
          cx = 960.0;
          cy = 575.0;
          enabled = true;
          output = "DP-3";
          placement_height = 1080.0;
          placement_width = 1920.0;
          rotation = 0.0;
          type = "login_box";
          settings = {
            background_color = "surface_variant";
            background_opacity = 0.88;
            background_radius = 32.0;
            center_password_text = false;
            input_opacity = 1.0;
            input_radius = 32.0;
            layout = "compact";
            show_caps_lock = true;
            show_keyboard_layout = true;
            show_login_button = true;
            show_media = false;
            show_session_buttons = true;
            show_unlock_hint = true;
            show_weather = false;
          };
        };
        widget."lockscreen-login-box@DP-4" = {
          box_height = 196.0;
          box_width = 810.0;
          cx = 960.0;
          cy = 898.0;
          enabled = true;
          output = "DP-4";
          placement_height = 1080.0;
          placement_width = 1920.0;
          rotation = 0.0;
          type = "login_box";
          settings = {
            background_color = "surface_variant";
            background_opacity = 0.88;
            background_radius = 12.0;
            center_password_text = false;
            input_opacity = 1.0;
            input_radius = 6.0;
            layout = "regular";
            show_caps_lock = true;
            show_keyboard_layout = true;
            show_login_button = true;
            show_media = true;
            show_session_buttons = true;
            show_unlock_hint = true;
            show_weather = true;
          };
        };
        widget."lockscreen-login-box@eDP-1" = {
          box_height = 70.0;
          box_width = 400.0;
          cx = 705.0;
          cy = 520.0;
          enabled = true;
          output = "eDP-1";
          placement_height = 940.0;
          placement_width = 1410.0;
          rotation = 0.0;
          type = "login_box";
          settings = {
            background_color = "surface_variant";
            background_opacity = 0.61;
            background_radius = 32.0;
            center_password_text = false;
            input_opacity = 1.0;
            input_radius = 32.0;
            layout = "compact";
            show_caps_lock = true;
            show_keyboard_layout = true;
            show_login_button = true;
            show_media = true;
            show_session_buttons = true;
            show_unlock_hint = true;
            show_weather = false;
          };
        };
        widget."lockscreen-widget-0000000000000001" = {
          box_height = 192.0;
          box_width = 416.0;
          cx = 705.0;
          cy = 278.0;
          enabled = true;
          output = "eDP-1";
          placement_height = 940.0;
          placement_width = 1410.0;
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
          box_height = 112.0;
          box_width = 1392.0;
          cx = 711.0;
          cy = 884.0;
          enabled = true;
          output = "eDP-1";
          placement_height = 940.0;
          placement_width = 1410.0;
          rotation = 0.0;
          type = "audio_visualizer";
          settings = {
            background = false;
            bands = 32;
            centered = true;
            reversed = false;
            show_when_idle = false;
          };
        };
        widget."lockscreen-widget-0000000000000003" = {
          box_height = 192.0;
          box_width = 416.0;
          cx = 960.0;
          cy = 316.0;
          enabled = true;
          output = "DP-3";
          placement_height = 1080.0;
          placement_width = 1920.0;
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
        widget."lockscreen-widget-0000000000000008" = {
          box_height = 128.0;
          box_width = 240.0;
          cx = 1152.0;
          cy = 520.0;
          enabled = true;
          output = "HDMI-A-1";
          placement_height = 1296.0;
          placement_width = 2304.0;
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
      };

      nightlight.enabled = true;

      notification.background_opacity = 0.7;

      osd.background_opacity = 0.7;

      plugins = {
        auto_update = "all";
        enabled = [
          "yuuto/calculator"
          "kenn/keybind-cheatsheet"
          "cleboost/ssh-launcher"
          "davemhammer/obsidian"
          "fel/ocr"
          "andrewdems/vpn-manager"
        ];
      };

      plugin_settings = {
        "andrewdems/vpn-manager".auto_connect_enabled = true;
        "davemhammer/obsidian".vault_path = "${config.nextcloudPath}/Obsidian";
        "noctalia/bitwarden".server_url = config.bitwardenURL;
        "yuuto/calculator".angle_unit = "deg";
      };

      shell = {
        avatar_path = config.avatarPath;
        date_format = "%A, %x";
        font_family = lib.mkForce "JetBrainsMono Nerd Font Propo";
        launch_apps_as_systemd_services = true;
        polkit_agent = true;
        screen_time_enabled = true;
        settings_show_advanced = true;
        telemetry_enabled = false;
        show_location = true;
        time_format = "{:%H:%M}";
        panel = {
          clipboard_placement = "floating";
          clipboard_position = "center";
          control_center_placement = "attached";
          control_center_position = "auto";
          launcher_placement = "floating";
          launcher_position = "center";
          polkit_placement = "floating";
          polkit_position = "center";
          session_placement = "attached";
          session_position = "auto";
          transparency_mode = "soft";
          wallpaper_placement = "attached";
          wallpaper_position = "auto";
        };
        screen_corners = {
          enabled = false;
          size = 41;
        };
        screenshot = {
          save_to_file = true;
          directory = "~/Pictures/screenshots";
          copy_to_clipboard = true;
          freeze_screen = true;
          show_cursor = false;
          pipe_to_command = true;
          pipe_command = "swappy -f -";
        };
      };

      wallpaper = {
        directory = "/etc/nixos/dotfiles/wallpapers";
        directory_dark = "/etc/nixos/dotfiles/wallpapers/dark";
        directory_light = "/etc/nixos/dotfiles/wallpapers/light";
        enabled = true;
        fill_mode = "stretch";
        per_monitor_directories = false;
        transition = [ "honeycomb" ];
        transition_duration = 1500.0;
        transition_on_startup = false;
        automation = {
          enabled = false;
          interval_seconds = 1800;
          order = "random";
          recursive = true;
        };
      };

      weather = {
        effects = true;
        enabled = true;
        refresh_minutes = 30;
        unit = "metric";
      };

      widget = {
        bar.type = "yuuto/calculator:bar";
        bar_3.type = "andrewdems/vpn-manager:bar";
        battery = { capsule = true; type = "battery"; };
        control-center = { scale = 1.25; type = "control-center"; };
        date = { format = "{:%a %d %b}"; type = "clock"; };
        media = {
          art_size = 16.0;
          hide_when_no_media = true;
          max_length = 220.0;
          min_length = 80.0;
          scale = 0.9;
          title_scroll = "none";
          type = "media";
        };
        network = { show_label = false; type = "network"; };
        notes.type = "noctalia/notes:notes";
        ocr.type = "fel/ocr:ocr";
        session = { enabled = false; type = "session"; };
        spacer_2.type = "spacer";
        status.type = "davemhammer/obsidian:status";
        tray = {
          capsule = true;
          drawer = false;
          hidden = [ "Blueman" "Réseau" ];
          type = "tray";
        };
        volume = {
          mute_color = "secondary";
          scale = 0.95;
          show_label = false;
          type = "volume";
        };
        workspaces = { show_all_outputs = true; type = "workspaces"; };
      };
    };
  };
}
