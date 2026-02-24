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
      monitor = [ ",preferred,auto,1.6" ];
      xwayland.force_zero_scaling = true;
      "$mainMod" = "SUPER";
      "$terminal" = "kitty";
      "$fileManager" = "thunar";
      "$browser" = "firefox";
      "$browserPrivate" = "firefox --private-window";
      "$termFileManager" = "lf";
      "$menu" = "rofi-launcher";
      "$systman" = "btop";
      "$screenshot" = ''grim -g "$(slurp)" - | swappy -f -'';
      "$clipboard" = "cliphist list | wofi --dmenu | cliphist decode | wl-copy";
      "$powermenu" = "rofi-powermenu";
      "$lockscreen" = "hyprlock";
      exec-once = "${startupScript}/bin/start";
      general = {
        gaps_in = 2;
        gaps_out = 2;
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
        disable_splash_rendering = true;
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
        "$mainMod, P, pseudo,"
        "$mainMod, J, togglesplit,"
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
    };

    extraConfig = ''
      # PulseAudio Volume Control
      windowrule = float on, size 800 600, center on, match:class ^(org\.pulseaudio\.pavucontrol)$

      # Nextcloud Client
      windowrule = float on, size 873 586, center on, match:class ^(com\.nextcloud\.desktopclient\.nextcloud)$

      # Blueman Bluetooth Manager
      windowrule = float on, size 700 500, center on, match:class ^(\.blueman-manager-wrapped)$

      # Thunar
      windowrule = float on, size 1000 700, center on, match:class ^(thunar)$

      # Network Manager
      windowrule = float on, size 800 600, center on, match:class ^(nm-connection-editor)$
      windowrule = float on, size 400 300, center on, match:class ^(nm-applet)$

      # OpenRGB
      windowrule = float on, size 1000 700, center on, match:class ^(openrgb)$

      # CoolerControl
      windowrule = float on, size 908 678, center on, match:class ^(org\.coolercontrol\.CoolerControl)$

      # Mullvad VPN (top-right)
      windowrule = float on, size 320 568, move 2232 50, pin on, match:class ^(Mullvad VPN)$

      # Proton VPN
      windowrule = float on, size 403 600, center on, pin on, match:title ^(Proton VPN)$

      # KDE Connect
      windowrule = float on, size 762 687, center on, match:class ^(org\.kde\.kdeconnect\.app)$

      # Firefox PiP
      windowrule = float on, pin on, size 35% 35%, move 64% 4%, no_blur on, no_shadow on, no_anim on, match:title ^(Incrustation vidéo)$

      # Firefox extensions / cookies
      windowrule = float on, size 490 154, center on, match:title ^(Suppression des cookies.*)$
      windowrule = float on, match:title ^(Extension:.*)$

      # Gnome Calculator
      windowrule = float on, size 360 616, match:class ^(org\.gnome\.Calculator)$

      # Keyring manager
      windowrule = float on, center on, pin on, match:class ^(gcr-prompter)$

      # Waybar monitors
      windowrule = float on, size 1200 800, center on, match:class ^(disk-monitor)$
      windowrule = float on, size 1200 800, center on, match:class ^(system-monitor)$

      # Virt-manager
      windowrule = float on, size 800 600, center on, match:class ^(virt-manager)$

      # System config printer
      windowrule = float on, size 700 500, center on, match:class ^(system-config-printer)$

      # PrismLauncher
      windowrule = float on, size 1100 700, center on, match:class ^(org\.prismlauncher\.PrismLauncher)$

      # Vesktop (Discord)
      windowrule = float on, size 900 600, center on, match:class ^(vesktop)$

      # mpv
      windowrule = idle_inhibit fullscreen, match:class ^(mpv)$

      # Steam - fenetres flottantes
      windowrule = float on, match:title ^(Steam Guard|Paramètres Steam|Liste de contacts|Offres spéciales)$
      windowrule = size 480 480, center on, match:title ^(Liste de contacts)$

      # Steam - client (deja flottant, centrage uniquement)
      windowrule = center on, match:class ^(steam)$

      # Steam - jeux uniquement
      windowrule = fullscreen on, immediate on, idle_inhibit fullscreen, match:class ^(steam_app_.+)$

      # Wine / Lutris
      windowrule = fullscreen on, immediate on, idle_inhibit fullscreen, workspace special:games, match:class ^(wine|lutris)$

      # Autres emulateurs et lanceurs
      windowrule = fullscreen on, match:class ^(minecraft-launcher|gamemoderun|heroic|legendary|bottles|retroarch|dolphin-emu|pcsx2-qt|rpcs3|yuzu|citra|hl2_linux|csgo_linux64|dota2)$
    '';
  };
}
