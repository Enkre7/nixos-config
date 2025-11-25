{ config, lib, pkgs, inputs, ... }:
let
  stylix = config.lib.stylix.colors;
  startupScript = pkgs.writeShellScriptBin "start" ''
    eval $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
    export SSH_AUTH_SOCK
    ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &    
    
    pkill -x waybar || true
    sleep 0.5
    ${pkgs.waybar}/bin/waybar &

    pkill -x swaync || true
    sleep 0.5
    ${pkgs.swaynotificationcenter}/bin/swaync &
    
    ${pkgs.networkmanagerapplet}/bin/nm-applet &
    ${pkgs.blueman}/bin/blueman-applet &
    ${pkgs.udiskie}/bin/udiskie &
    ${pkgs.gammastep}/bin/gammastep &
    command -v thunar >/dev/null 2>&1 && thunar --daemon &
    command -v coolercontrol >/dev/null 2>&1 && coolercontrol &
    command -v openrgb >/dev/null 2>&1 && openrgb --server --startminimized -m static -c 00FF00 -b 100 &

    sleep 1
    command -v vesktop >/dev/null 2>&1 && vesktop --start-minimized &
    sleep 0.5
    command -v mullvad-vpn >/dev/null 2>&1 && mullvad-vpn &
    command -v protonvpn-app >/dev/null 2>&1 && protonvpn-app &
    
    wl-paste --watch cliphist store &
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
      monitor = [
        ",preferred,auto,1.6"
      ];
      xwayland.force_zero_scaling = true;

      "$mainMod" = "SUPER";
      "$terminal" = "kitty";
      "$fileManager" = "thunar";
      "$browser" = "firefox";
      "$browserPrivate" = "firefox --private-window";
      "$termFileManager" = "lf";
      "$menu" = "rofi-launcher";
      "$systman" = "btop";
      "$screenshot" = "grim -g \"$(slurp)\" - | swappy -f -";
      "$clipboard" = "cliphist list | wofi --dmenu | cliphist decode | wl-copy";
      "$powermenu" = "rofi-powermenu";
      "$lockscreen" = "hyprlock";

      exec-once = ''${startupScript}/bin/start'';

      general = {
        gaps_in = 3;
        gaps_out = 5;
        border_size = 2;
        "col.active_border" = lib.mkForce "rgb(${stylix.base0D})";
        "col.inactive_border" = lib.mkForce "rgb(${stylix.base03})";
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = 5;
        active_opacity = "1.0";
        inactive_opacity = "1.0";
        blur = {
          enabled = true;
          size = 7;
          passes = 1;
          vibrancy = "0.1696";
          popups = true;
        };
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };

      input = {
        kb_layout = "fr";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";
        follow_mouse = 1;
        sensitivity = 0;
        force_no_accel = 0;
        numlock_by_default = true;
        touchpad = {
          natural_scroll = false;
          scroll_factor = 0.7;
          disable_while_typing = false;
        };
      };

      bind = [
        "$mainMod, A, exec, $powermenu"
        "$mainMod, Q, exec, $terminal"
        "$mainMod, C, killactive,"
        "$mainMod, E, exec, $terminal -e $systman"
        "$mainMod, T, exec, $fileManager"
        "$mainMod, G, exec, $terminal -e $termFileManager"
        "$mainMod, V, togglefloating,"
        "$mainMod, R, exec, $menu"
        "$mainMod, P, pseudo," # dwindle
        "$mainMod, J, togglesplit," # dwindle
        "$mainMod, F, exec, $browser"
        "$mainMod, B, fullscreen"
        "$mainMod SHIFT, F, exec, $browserPrivate"
        "$mainMod, Left, movefocus, l"
        "$mainMod, Right, movefocus, r"
        "$mainMod, Up, movefocus, u"
        "$mainMod, Down, movefocus, d"
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
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        "$mainMod, Right, workspace, e+1"
        "$mainMod, Left, workspace, e-1"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioPlay, exec, playerctl play-pause"
        ",XF86AudioPause, exec, playerctl play-pause"
        ",XF86AudioNext, exec, playerctl next"
        ",XF86AudioPrev, exec, playerctl previous"
        ",XF86AudioMedia, exec, $lockscreen"
        ",Print, exec, $screenshot"
        "Control_L Alt_L, V, exec, $clipboard"
      ];

      binde = [
        ",XF86AudioRaiseVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 | wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 | wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ",XF86MonBrightnessUP, exec, brightnessctl set +5%"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      bindl = [
        ",switch:Lid Switch, exec, hyprlock"
      ];

      windowrule = [
        # PulseAudio Volume Control
        "match:class org.pulseaudio.pavucontrol, float on"
        "match:class org.pulseaudio.pavucontrol, size 800 600"
        "match:class org.pulseaudio.pavucontrol, center on"
        "match:class org.pulseaudio.pavucontrol, animation slide"

        # Nextcloud Client
        "match:class com.nextcloud.desktopclient.nextcloud, float on"
        "match:class com.nextcloud.desktopclient.nextcloud, size 873 586"
        "match:class com.nextcloud.desktopclient.nextcloud, center on"
        "match:class com.nextcloud.desktopclient.nextcloud, animation slide"

        # Blueman Bluetooth Manager
        "match:class blueman-manager, float on"
        "match:class blueman-manager, size 700 500"
        "match:class blueman-manager, center on"
        "match:class blueman-manager, animation slide"

        # Network Manager (nm-connection-editor)
        "match:class nm-connection-editor, float on"
        "match:class nm-connection-editor, size 800 600"
        "match:class nm-connection-editor, center on"
        "match:class nm-connection-editor, animation slide"

        # Network Manager Applet
        "match:class nm-applet, float on"
        "match:class nm-applet, size 400 300"
        "match:class nm-applet, center on"
        "match:class nm-applet, animation slide"

        # OpenRGB
        "match:class openrgb, float on"
        "match:class openrgb, size 1000 700"
        "match:class openrgb, center on"
        "match:class openrgb, animation slide"

        # CoolerControl
        "match:class org.coolercontrol.CoolerControl, float on"
        "match:class org.coolercontrol.CoolerControl, size 908 678"
        "match:class org.coolercontrol.CoolerControl, center on"
        "match:class org.coolercontrol.CoolerControl, animation slide"

        # Mullvad VPN
        "match:class Mullvad VPN, pin on"
        "match:class Mullvad VPN, rounding 10"

        # Proton VPN
        "match:title Proton VPN, pin on"
        "match:title Proton VPN, size 403 600"
        "match:title Proton VPN, center on"

        # Firefox browsers
        "match:title Incrustation vidéo, float on"
        "match:title Incrustation vidéo, pin on"
        "match:title Incrustation vidéo, keep_aspect_ratio on"
        "match:title Incrustation vidéo, border_size 0"
        "match:title Incrustation vidéo, size 35% 35%"
        "match:title Incrustation vidéo, move 911 50"
        "match:title Suppression des cookies.*, size 490 154"
        "match:title Suppression des cookies.*, float on"
        "match:title Suppression des cookies.*, center on"
        "match:title Extension:.*, float on"

        # Gnome calculator
        "match:class org.gnome.Calculator, float on"
        "match:class org.gnome.Calculator, size 360 616"
        "match:class org.gnome.Calculator, move 1043 52"

        # Keyring manager
        "match:class gcr-prompter, dim_around on"
        "match:class gcr-prompter, pin on"
        "match:class gcr-prompter, border_size 3"
        "match:class gcr-prompter, animation slide"

        # Disk monitor (waybar)
        "match:class disk-monitor, float on"
        "match:class disk-monitor, size 1200 800"
        "match:class disk-monitor, center on"
        "match:class disk-monitor, animation slide"

        # System monitor (waybar)
        "match:class system-monitor, float on"
        "match:class system-monitor, size 1200 800"
        "match:class system-monitor, center on"
        "match:class system-monitor, animation slide"

        # Steam
        "match:title Steam Guard, float on"
        "match:title Paramètres Steam, float on"
        "match:title Liste de contacts, float on"
        "match:title Offres spéciales, float on"
        "match:title Paramètres Steam, border_size 0"
        "match:title Offres spéciales, border_size 0"
        "match:title Liste de contacts, border_size 0"
        "match:title Liste de contacts, size 480 480"
        "match:title Liste de contacts, center on"
        "match:class steam_app_, center on"
        "match:class steam_app_.*, fullscreen on"
        "match:class steam_app_.*, animation slide"

        # Wine/Lutris Games
        "match:class wine, fullscreen on"
        "match:class lutris, fullscreen on"
        "match:class wine, workspace special:games"
        "match:class lutris, workspace special:games"

        # Other Games
        "match:class minecraft-launcher, fullscreen on"
        "match:title Minecraft, fullscreen on"
        "match:class gamemoderun, fullscreen on"
        "match:class heroic, fullscreen on"
        "match:class legendary, fullscreen on"
        "match:class bottles, fullscreen on"
        "match:class retroarch, fullscreen on"
        "match:class dolphin-emu, fullscreen on"
        "match:class pcsx2-qt, fullscreen on"
        "match:class rpcs3, fullscreen on"
        "match:class yuzu, fullscreen on"
        "match:class citra, fullscreen on"

        # Specific Games Patterns
        "match:title .*[Gg]ame.*, fullscreen on"
        "match:class com.valvesoftware.Steam, fullscreen on"
        "match:class hl2_linux, fullscreen on"
        "match:class csgo_linux64, fullscreen on"
        "match:class dota2, fullscreen on"

        # Generic Games Patterns
        "match:class .*[Gg]ame.*, fullscreen on"
        "match:title .*[Ff]ullscreen.*, fullscreen on"
      ];
    };
  };
}

