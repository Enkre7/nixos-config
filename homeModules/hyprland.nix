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
    thunar --daemon &
    coolercontrol &
    openrgb --server --startminimized -m static -c 00FF00 -b 100 &

    sleep 1
    ${pkgs.vesktop}/bin/vesktop --start-minimized &
    sleep 0.5
    ${pkgs.mullvad-vpn}/bin/mullvad-vpn &
    ${pkgs.protonvpn-gui}/bin/protonvpn-app &
    
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

    #plugins = [
    #  inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
    #];

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
      #"$menu" = "pgrep wofi >/dev/null 2>&1 && killall wofi || wofi --location=top -y 15";
      "$menu" = "rofi-launcher";
      "$systman" = "btop";
      "$screenshot" = "grim -g \"$(slurp)\" - | swappy -f -";
      "$clipboard" = "cliphist list | wofi --dmenu | cliphist decode | wl-copy";
      #"$powermenu" = "wlogout-wrapper";
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
        # Move focus with mainMod + arrow keys
        "$mainMod, Left, movefocus, l"
        "$mainMod, Right, movefocus, r"
        "$mainMod, Up, movefocus, u"
        "$mainMod, Down, movefocus, d"
        # Switch workspaces
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
        # Move active window to a workspace
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
        # Example special workspace (scratchpad)
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"
        # Scroll through existing workspaces
        # Mouse
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        # Keyboard
        "$mainMod, Right, workspace, e+1"
        "$mainMod, Left, workspace, e-1"
        # Sound
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioPlay, exec, playerctl play-pause"
        ",XF86AudioPause, exec, playerctl play-pause"
        ",XF86AudioNext, exec, playerctl next"
        ",XF86AudioPrev, exec, playerctl previous"
        # Lock Session
        ",XF86AudioMedia, exec, $lockscreen"
        # Screenshot
        ",Print, exec, $screenshot"
        # Clipboard
        "Control_L Alt_L, V, exec, $clipboard"
      ];

      binde = [
        # Sound
        ",XF86AudioRaiseVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 | wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 | wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"
        # Screen Brightness
        ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ",XF86MonBrightnessUP, exec, brightnessctl set +5%"
      ];

      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      bindl = [
        ",switch:Lid Switch, exec, hyprlock"
      ];

      # To get windows's names: hyprctl clients
      windowrulev2 = [
        # PulseAudio Volume Control
        "float, class:org.pulseaudio.pavucontrol"
        "size 800 600, class:org.pulseaudio.pavucontrol"
        "center, class:org.pulseaudio.pavucontrol"
        "animation slide, class:org.pulseaudio.pavucontrol"

        # Nextcloud Client
        "float, class:com.nextcloud.desktopclient.nextcloud"
        "size 873 586, class:com.nextcloud.desktopclient.nextcloud"
        "center, class:com.nextcloud.desktopclient.nextcloud"
        "animation slide, class:com.nextcloud.desktopclient.nextcloud"

        # Blueman Bluetooth Manager
        "float, class:^(blueman-manager)$"
        "size 700 500, class:^(blueman-manager)$"
        "center, class:^(blueman-manager)$"
        "animation slide, class:^(blueman-manager)$"

        # Network Manager (nm-connection-editor)
        "float, class:^(nm-connection-editor)$"
        "size 800 600, class:^(nm-connection-editor)$"
        "center, class:^(nm-connection-editor)$"
        "animation slide, class:^(nm-connection-editor)$"

        # Network Manager Applet
        "float, class:^(nm-applet)$"
        "size 400 300, class:^(nm-applet)$"
        "center, class:^(nm-applet)$"
        "animation slide, class:^(nm-applet)$"

        # OpenRGB
        "float, class:^(openrgb)$"
        "size 1000 700, class:^(openrgb)$"
        "center, class:^(openrgb)$"
        "animation slide, class:^(openrgb)$"

        # CoolerControl
        "float, class:^(org.coolercontrol.CoolerControl)$"
        "size 900 600, class:^(org.coolercontrol.CoolerControl)$"
        "center, class:^(org.coolercontrol.CoolerControl)$"
        "animation slide, class:^(org.coolercontrol.CoolerControl)$"

        # Mullvad VPN
        "pin, class:(Mullvad VPN)"
        "rounding 10, class:(Mullvad VPN)"

        # Proton VPN
        "pin, title:(Proton VPN)"
        "size 403 600, title:(Proton VPN)"
        "center, title:(Proton VPN)"

        # Firefox browsers
        "float, title:^(Incrustation vidéo)$"
        "pin, title:^(Incrustation vidéo)$"
        "keepaspectratio, title:^(Incrustation vidéo)$"
        "noborder, title:^(Incrustation vidéo)$"
        "size 35% 35%, title:^(Incrustation vidéo)$"
        "move 911 50, title:^(Incrustation vidéo)$"
        "size 490 154, title:^(Suppression des cookies.*)$"
        "float, title:^(Extension:.*)$"

        # Gnome calculator
        "float, class:(org.gnome.Calculator)" # All modes
        #"size 670 700, class:(org.gnome.Calculator)" # Basic mode
        "size 360 616, class:(org.gnome.Calculator)"
        "move 1043 52, class:(org.gnome.Calculator)"

        # Keyring manager
        "dimaround, class:(gcr-prompter)"
        "pin, class:(gcr-prompter)"
        "bordersize 3, class:(gcr-prompter)"
        "animation slide,, class:(gcr-prompter)"

        # Disk monitor (waybar)
        "float, class:^(disk-monitor)$"
        "size 1200 800, class:^(disk-monitor)$"
        "center, class:^(disk-monitor)$"
        "animation slide, class:^(disk-monitor)$"

        # System monitor (waybar)
        "float, class:^(system-monitor)$"
        "size 1200 800, class:^(system-monitor)$"
        "center, class:^(system-monitor)$"
        "animation slide, class:^(system-monitor)$"

        # Steam
        "float, title:^(Steam Guard)$"
        "float, title:^(Paramètres Steam)$"
        "float, title:^(Liste de contacts)$"
        "float, title:^(Offres spéciales)$"
        "noborder, title:^(Paramètres Steam)$"
        "noborder, title:^(Offres spéciales)$"
        "noborder, title:^(Liste de contacts)$"
        "size 480 480, title:^(Liste de contacts)"
        "center, title:^(Liste de contacts)"
        "center, class:^(steam_app_)$"
        "fullscreen, class:^(steam_app_).*"
        "animation slide, class:^(steam_app_).*"

        # Wine/Lutris Games
        "fullscreen, class:^(wine)$"
        "fullscreen, class:^(lutris)$"
        "workspace special:games, class:^(wine)$"
        "workspace special:games, class:^(lutris)$"

        # Other Games
        "fullscreen, class:^(minecraft-launcher)$"
        "fullscreen, title:^(Minecraft)(.*)$"
        "fullscreen, class:^(gamemoderun)$"
        "fullscreen, class:^(heroic)$"
        "fullscreen, class:^(legendary)$"
        "fullscreen, class:^(bottles)$"
        "fullscreen, class:^(retroarch)$"
        "fullscreen, class:^(dolphin-emu)$"
        "fullscreen, class:^(pcsx2-qt)$"
        "fullscreen, class:^(rpcs3)$"
        "fullscreen, class:^(yuzu)$"
        "fullscreen, class:^(citra)$"

        # Specific Games Patterns
        "fullscreen, title:.*[Gg]ame.*"
        "fullscreen, class:^(com\.valvesoftware\.Steam)$"
        "fullscreen, class:^(hl2_linux)$"
        "fullscreen, class:^(csgo_linux64)$"
        "fullscreen, class:^(dota2)$"

        # Generic Games Patterns
        "fullscreen, class:.*[Gg]ame.*"
        "fullscreen, title:.*[Ff]ullscreen.*"
      ];
    };
  };
}
