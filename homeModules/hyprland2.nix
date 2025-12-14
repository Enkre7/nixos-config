{ config, lib, pkgs, inputs, ... }:
let
  stylix = config.lib.stylix.colors;
  
  startupScript = pkgs.writeShellScriptBin "start" ''
    eval $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
    export SSH_AUTH_SOCK
    ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &    
    
    pkill -x waybar || true
    sleep 0.3
    ${pkgs.waybar}/bin/waybar &

    pkill -x swaync || true
    sleep 0.3
    ${pkgs.swaynotificationcenter}/bin/swaync &
    
    ${pkgs.networkmanagerapplet}/bin/nm-applet --indicator &
    ${pkgs.blueman}/bin/blueman-applet &
    ${pkgs.udiskie}/bin/udiskie --tray &
    ${pkgs.gammastep}/bin/gammastep &
    command -v thunar >/dev/null 2>&1 && thunar --daemon &
    command -v coolercontrol >/dev/null 2>&1 && coolercontrol &
    command -v openrgb >/dev/null 2>&1 && openrgb --server --startminimized -m static -c 00FF00 -b 100 &

    sleep 0.5
    command -v vesktop >/dev/null 2>&1 && vesktop --start-minimized &
    command -v mullvad-vpn >/dev/null 2>&1 && mullvad-vpn &
    command -v protonvpn-app >/dev/null 2>&1 && protonvpn-app &
    
    wl-paste --type text --watch cliphist store &
    wl-paste --type image --watch cliphist store &
  '';
in
{
  imports = [ inputs.hyprland.homeManagerModules.default ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    systemd.variables = [ "--all" ];

    settings = {
      # Variables
      "$mainMod" = "SUPER";
      "$terminal" = "kitty";
      "$fileManager" = "thunar";
      "$browser" = "firefox";
      "$browserPrivate" = "firefox --private-window";
      "$termFileManager" = "lf";
      "$menu" = "rofi-launcher";
      "$systman" = "btop";
      "$screenshot" = "grim -g \"$(slurp)\" - | swappy -f -";
      "$screenshotFull" = "grim - | swappy -f -";
      "$clipboard" = "cliphist list | wofi --dmenu | cliphist decode | wl-copy";
      "$powermenu" = "rofi-powermenu";
      "$lockscreen" = "hyprlock";
      "$colorpicker" = "hyprpicker -a";

      exec-once = ''${startupScript}/bin/start'';

      monitor = [
        ",preferred,auto,1.6"
      ];
      
      xwayland.force_zero_scaling = true;

      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];

      input = {
        kb_layout = "fr";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";
        
        follow_mouse = 1;
        mouse_refocus = false;
        float_switch_override_focus = 2;
        
        sensitivity = 0;
        accel_profile = "flat";
        force_no_accel = false;
        
        numlock_by_default = true;
        
        touchpad = {
          natural_scroll = false;
          scroll_factor = 0.7;
          disable_while_typing = false;
          tap-to-click = true;
          drag_lock = false;
          clickfinger_behavior = true;
        };
      };

      general = {
        gaps_in = 3;
        gaps_out = 5;
        gaps_workspaces = 0;
        border_size = 2;
        "col.active_border" = lib.mkForce "rgb(${stylix.base0D})";
        "col.inactive_border" = lib.mkForce "rgb(${stylix.base03})";
        
        resize_on_border = true;
        extend_border_grab_area = 15;
        hover_icon_on_border = true;
        
        allow_tearing = false;
        layout = "dwindle";
        
        no_focus_fallback = false;
      };

      decoration = {
        rounding = 8;
        active_opacity = 1.0;
        inactive_opacity = 0.95;
        fullscreen_opacity = 1.0;
        
        drop_shadow = true;
        shadow_range = 20;
        shadow_render_power = 3;
        shadow_offset = "0 2";
        "col.shadow" = "rgba(00000066)";
        "col.shadow_inactive" = "rgba(00000033)";
        
        dim_inactive = false;
        dim_strength = 0.05;
        dim_special = 0.5;
        
        blur = {
          enabled = true;
          size = 8;
          passes = 2;
          ignore_opacity = true;
          new_optimizations = true;
          xray = false;
          noise = 0.02;
          contrast = 0.9;
          brightness = 0.8;
          vibrancy = 0.2;
          vibrancy_darkness = 0.0;
          popups = true;
          popups_ignorealpha = 0.2;
        };
      };

      animations = {
        enabled = true;
        first_launch_animation = true;
        
        bezier = [
          "easeOutQuint,0.22, 1, 0.36, 1"
          "easeInOutCubic,0.65, 0, 0.35, 1"
          "linear,0, 0, 1, 1"
          "almostLinear,0.5, 0.5, 0.75, 1.0"
          "quick,0.15, 0, 0.1, 1"
        ];
        
        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint, slide"
          "windowsIn, 1, 4.1, easeOutQuint, slide"
          "windowsOut, 1, 4.3, quick, slide"
          "windowsMove, 1, 4.79, easeOutQuint, slide"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "fadeDim, 1, 3.03, linear"
          "workspaces, 1, 3.83, easeOutQuint, slide"
          "specialWorkspace, 1, 3.83, easeOutQuint, slidevert"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
        smart_split = false;
        smart_resizing = true;
        force_split = 0;
        split_width_multiplier = 1.0;
        no_gaps_when_only = 0;
        use_active_for_splits = true;
        default_split_ratio = 1.0;
      };

      master = {
        allow_small_split = false;
        special_scale_factor = 0.8;
        mfact = 0.55;
        new_status = "slave";
        new_on_top = false;
        no_gaps_when_only = 0;
        orientation = "left";
        inherit_fullscreen = true;
        always_center_master = false;
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        force_default_wallpaper = 0;
        
        vfr = true;
        vrr = 1;
        
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        
        always_follow_on_dnd = true;
        layers_hog_keyboard_focus = true;
        
        animate_manual_resizes = true;
        animate_mouse_windowdragging = true;
        
        disable_autoreload = false;
        
        enable_swallow = true;
        swallow_regex = "^(kitty)$";
        swallow_exception_regex = "^(wev)$";
        
        focus_on_activate = true;
        
        new_window_takes_over_fullscreen = 0;
        
        initial_workspace_tracking = 1;
        
        middle_click_paste = true;
      };

      cursor = {
        no_hardware_cursors = false;
        no_break_fs_vrr = false;
        min_refresh_rate = 24;
        hotspot_padding = 1;
        inactive_timeout = 0;
        no_warps = false;
        persistent_warps = false;
        warp_on_change_workspace = false;
        default_monitor = "";
        zoom_factor = 1.0;
        zoom_rigid = false;
        enable_hyprcursor = true;
        hide_on_key_press = false;
        hide_on_touch = true;
      };

      binds = {
        allow_workspace_cycles = true;
        workspace_back_and_forth = false;
        pass_mouse_when_bound = false;
        scroll_event_delay = 300;
        focus_preferred_method = 0;
        ignore_group_lock = false;
        movefocus_cycles_fullscreen = true;
      };

      group = {
        insert_after_current = true;
        "col.border_active" = "rgb(${stylix.base0D})";
        "col.border_inactive" = "rgb(${stylix.base03})";
        "col.border_locked_active" = "rgb(${stylix.base08})";
        "col.border_locked_inactive" = "rgb(${stylix.base03})";
        
        groupbar = {
          enabled = true;
          font_size = 10;
          gradients = false;
          height = 14;
          priority = 3;
          render_titles = true;
          scrolling = true;
          "col.active" = "rgb(${stylix.base0D})";
          "col.inactive" = "rgb(${stylix.base03})";
          "col.locked_active" = "rgb(${stylix.base08})";
          "col.locked_inactive" = "rgb(${stylix.base03})";
        };
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
        workspace_swipe_distance = 300;
        workspace_swipe_touch = false;
        workspace_swipe_invert = true;
        workspace_swipe_min_speed_to_force = 30;
        workspace_swipe_cancel_ratio = 0.5;
        workspace_swipe_create_new = true;
        workspace_swipe_direction_lock = true;
        workspace_swipe_direction_lock_threshold = 10;
        workspace_swipe_forever = false;
        workspace_swipe_use_r = false;
      };

      # Keybindings
      bind = [
        # System
        "$mainMod, A, exec, $powermenu"
        "$mainMod SHIFT, L, exec, $lockscreen"
        
        # Applications
        "$mainMod, Q, exec, $terminal"
        "$mainMod, E, exec, $terminal -e $systman"
        "$mainMod, T, exec, $fileManager"
        "$mainMod, G, exec, $terminal -e $termFileManager"
        "$mainMod, F, exec, $browser"
        "$mainMod SHIFT, F, exec, $browserPrivate"
        "$mainMod, R, exec, $menu"
        
        # Window management
        "$mainMod, C, killactive,"
        "$mainMod, V, togglefloating,"
        "$mainMod, P, pseudo,"
        "$mainMod, J, togglesplit,"
        "$mainMod, B, fullscreen, 0"
        "$mainMod SHIFT, B, fullscreen, 1"
        "$mainMod, M, fullscreen, 2"
        
        # Focus
        "$mainMod, Left, movefocus, l"
        "$mainMod, Right, movefocus, r"
        "$mainMod, Up, movefocus, u"
        "$mainMod, Down, movefocus, d"
        "$mainMod, H, movefocus, l"
        "$mainMod, L, movefocus, r"
        "$mainMod, K, movefocus, u"
        "$mainMod SHIFT, J, movefocus, d"
        
        # Move windows
        "$mainMod SHIFT, Left, movewindow, l"
        "$mainMod SHIFT, Right, movewindow, r"
        "$mainMod SHIFT, Up, movewindow, u"
        "$mainMod SHIFT, Down, movewindow, d"
        "$mainMod SHIFT, H, movewindow, l"
        "$mainMod SHIFT, L, movewindow, r"
        "$mainMod SHIFT, K, movewindow, u"
        
        # Resize windows
        "$mainMod CTRL, Left, resizeactive, -50 0"
        "$mainMod CTRL, Right, resizeactive, 50 0"
        "$mainMod CTRL, Up, resizeactive, 0 -50"
        "$mainMod CTRL, Down, resizeactive, 0 50"
        "$mainMod CTRL, H, resizeactive, -50 0"
        "$mainMod CTRL, L, resizeactive, 50 0"
        "$mainMod CTRL, K, resizeactive, 0 -50"
        "$mainMod CTRL, J, resizeactive, 0 50"
        
        # Workspaces
        "$mainMod, code:10, workspace, 1"
        "$mainMod, code:11, workspace, 2"
        "$mainMod, code:12, workspace, 3"
        "$mainMod, code:13, workspace, 4"
        "$mainMod, code:14, workspace, 5"
        "$mainMod, code:15, workspace, 6"
        "$mainMod, code:16, workspace, 7"
        "$mainMod, code:17, workspace, 8"
        "$mainMod, code:18, workspace, 9"
        "$mainMod, code:19, workspace, 10"
        
        "$mainMod SHIFT, code:10, movetoworkspace, 1"
        "$mainMod SHIFT, code:11, movetoworkspace, 2"
        "$mainMod SHIFT, code:12, movetoworkspace, 3"
        "$mainMod SHIFT, code:13, movetoworkspace, 4"
        "$mainMod SHIFT, code:14, movetoworkspace, 5"
        "$mainMod SHIFT, code:15, movetoworkspace, 6"
        "$mainMod SHIFT, code:16, movetoworkspace, 7"
        "$mainMod SHIFT, code:17, movetoworkspace, 8"
        "$mainMod SHIFT, code:18, movetoworkspace, 9"
        "$mainMod SHIFT, code:19, movetoworkspace, 10"
        
        "$mainMod CTRL, code:10, movetoworkspacesilent, 1"
        "$mainMod CTRL, code:11, movetoworkspacesilent, 2"
        "$mainMod CTRL, code:12, movetoworkspacesilent, 3"
        "$mainMod CTRL, code:13, movetoworkspacesilent, 4"
        "$mainMod CTRL, code:14, movetoworkspacesilent, 5"
        "$mainMod CTRL, code:15, movetoworkspacesilent, 6"
        "$mainMod CTRL, code:16, movetoworkspacesilent, 7"
        "$mainMod CTRL, code:17, movetoworkspacesilent, 8"
        "$mainMod CTRL, code:18, movetoworkspacesilent, 9"
        "$mainMod CTRL, code:19, movetoworkspacesilent, 10"
        
        # Special workspace
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"
        
        # Scroll workspaces
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        "$mainMod, Right, workspace, e+1"
        "$mainMod, Left, workspace, e-1"
        "$mainMod, Tab, workspace, e+1"
        "$mainMod SHIFT, Tab, workspace, e-1"
        
        # Screenshots
        ",Print, exec, $screenshot"
        "SHIFT, Print, exec, $screenshotFull"
        "CTRL, Print, exec, grim -g \"$(slurp)\" - | wl-copy"
        
        # Clipboard
        "CTRL ALT, V, exec, $clipboard"
        
        # Color picker
        "$mainMod SHIFT, C, exec, $colorpicker"
        
        # Groups
        "$mainMod, W, togglegroup"
        "$mainMod, comma, changegroupactive, b"
        "$mainMod, period, changegroupactive, f"
      ];

      binde = [
        # Volume
        ",XF86AudioRaiseVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"
        
        # Brightness
        ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ",XF86MonBrightnessUp, exec, brightnessctl set +5%"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      bindl = [
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioPlay, exec, playerctl play-pause"
        ",XF86AudioPause, exec, playerctl play-pause"
        ",XF86AudioNext, exec, playerctl next"
        ",XF86AudioPrev, exec, playerctl previous"
        ",XF86AudioMedia, exec, $lockscreen"
        ",switch:Lid Switch, exec, $lockscreen"
      ];

      # Window rules
      windowrule = [
        # Floating windows
        "float, class:^(org.pulseaudio.pavucontrol)$"
        "size 800 600, class:^(org.pulseaudio.pavucontrol)$"
        "center, class:^(org.pulseaudio.pavucontrol)$"
        
        "float, class:^(com.nextcloud.desktopclient.nextcloud)$"
        "size 873 586, class:^(com.nextcloud.desktopclient.nextcloud)$"
        "center, class:^(com.nextcloud.desktopclient.nextcloud)$"
        
        "float, class:^(blueman-manager)$"
        "size 700 500, class:^(blueman-manager)$"
        "center, class:^(blueman-manager)$"
        
        "float, class:^(nm-connection-editor)$"
        "size 800 600, class:^(nm-connection-editor)$"
        "center, class:^(nm-connection-editor)$"
        
        "float, class:^(nm-applet)$"
        "size 400 300, class:^(nm-applet)$"
        
        "float, class:^(openrgb)$"
        "size 1000 700, class:^(openrgb)$"
        "center, class:^(openrgb)$"
        
        "float, class:^(org.coolercontrol.CoolerControl)$"
        "size 908 678, class:^(org.coolercontrol.CoolerControl)$"
        "center, class:^(org.coolercontrol.CoolerControl)$"
        
        "float, class:^(Mullvad VPN)$"
        "pin, class:^(Mullvad VPN)$"
        
        "float, title:^(Proton VPN)$"
        "size 403 600, title:^(Proton VPN)$"
        "center, title:^(Proton VPN)$"
        "pin, title:^(Proton VPN)$"
        
        # Firefox PiP
        "float, title:^(Incrustation vidéo)$"
        "pin, title:^(Incrustation vidéo)$"
        "size 35% 35%, title:^(Incrustation vidéo)$"
        "move 64% 4%, title:^(Incrustation vidéo)$"
        
        "float, title:^(Suppression des cookies.*)$"
        "size 490 154, title:^(Suppression des cookies.*)$"
        "center, title:^(Suppression des cookies.*)$"
        
        "float, title:^(Extension:.*)$"
        
        # Calculator
        "float, class:^(org.gnome.Calculator)$"
        "size 360 616, class:^(org.gnome.Calculator)$"
        
        # Keyring
        "float, class:^(gcr-prompter)$"
        "center, class:^(gcr-prompter)$"
        "pin, class:^(gcr-prompter)$"
        
        # Steam
        "float, title:^(Steam Guard)$"
        "float, title:^(Paramètres Steam)$"
        "float, title:^(Liste de contacts)$"
        "float, title:^(Offres spéciales)$"
        "size 480 480, title:^(Liste de contacts)$"
        "center, title:^(Liste de contacts)$"
        
        # Games - fullscreen
        "fullscreen, class:^(steam_app_.*)$"
        "fullscreen, class:^(wine)$"
        "fullscreen, class:^(lutris)$"
        "fullscreen, class:^(minecraft-launcher)$"
        "fullscreen, title:^(Minecraft.*)$"
        "fullscreen, class:^(gamemoderun)$"
        
        # Opacity
        "opacity 0.95 0.85, class:^(thunar)$"
        "opacity 0.95 0.85, class:^(discord)$"
        "opacity 0.95 0.85, class:^(vesktop)$"
      ];

      windowrulev2 = [
        # Suppress activation token for Rofi
        "suppressevent maximize, class:.*"
        "idleinhibit focus, class:^(mpv)$"
        "idleinhibit focus, class:^(firefox)$, title:^(.*YouTube.*)$"
        "idleinhibit fullscreen, class:^(.*)$"
        
        # Tearing for games
        "immediate, class:^(steam_app_.*)$"
        "immediate, class:^(wine)$"
        "immediate, class:^(cs2)$"
        
        # Workspace assignments
        "workspace 2 silent, class:^(firefox)$"
        "workspace 3 silent, class:^(discord)$"
        "workspace 3 silent, class:^(vesktop)$"
        "workspace 4 silent, class:^(steam)$"
      ];

      # Layer rules
      layerrule = [
        "blur, waybar"
        "blur, rofi"
        "blur, notifications"
        "blur, gtk-layer-shell"
        "ignorezero, waybar"
        "ignorezero, rofi"
        "ignorezero, notifications"
      ];
    };
  };
}
