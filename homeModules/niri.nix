{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
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
    ${lib.optionalString (!config.isLaptop) "command -v coolercontrol >/dev/null 2>&1 && coolercontrol &"}
    ${lib.optionalString (!config.isLaptop) "command -v openrgb >/dev/null 2>&1 && openrgb --server --startminimized -m static -c 00FF00 -b 100 &"}

    sleep 1
    command -v vesktop >/dev/null 2>&1 && vesktop --start-minimized &
    sleep 0.5
    command -v mullvad-vpn >/dev/null 2>&1 && mullvad-vpn &
    command -v protonvpn-app >/dev/null 2>&1 && protonvpn-app &
    
    wl-paste --watch cliphist store &
  '';
in
{
  xdg.configFile."niri/config.kdl".text = ''
    
    input {
        keyboard {
            xkb {
                layout "fr"
            }
        }
        
        touchpad {
            tap
            natural-scroll false
            dwt false
            scroll-factor 0.7
        }
        
        mouse {
            accel-speed 0.0
            accel-profile "flat"
        }
        
        disable-power-key-handling
        warp-mouse-to-focus
        focus-follows-mouse
    }
    
    layout {
        gaps 5
        
        center-focused-column "never"
        
        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }
        
        default-column-width { proportion 0.5; }
        
        focus-ring {
            off
        }
        
        border {
            width 2
            active-color "#${stylix.base0D}"
            inactive-color "#${stylix.base03}"
        }
        
        struts {
            left 0
            right 0
            top 0
            bottom 0
        }
    }
    
    prefer-no-csd
    
    screenshot-path "~/Pictures/screenshots/screenshot-%Y-%m-%d_%H-%M-%S.png"
    
    hotkey-overlay {
        skip-at-startup
    }
    
    spawn-at-startup "${startupScript}/bin/start"
    
    animations {
        slowdown 1.0
        
        workspace-switch {
            spring damping-ratio=1.0 stiffness=1000 epsilon=0.0001
        }
        
        horizontal-view-movement {
            spring damping-ratio=1.0 stiffness=800 epsilon=0.0001
        }
        
        window-open {
            duration-ms 150
            curve "ease-out-expo"
        }
        
        window-close {
            duration-ms 150
            curve "ease-out-quad"
        }
        
        window-movement {
            spring damping-ratio=1.0 stiffness=800 epsilon=0.0001
        }
        
        window-resize {
            spring damping-ratio=1.0 stiffness=800 epsilon=0.0001
        }
        
        config-notification-open-close {
            spring damping-ratio=0.6 stiffness=1000 epsilon=0.001
        }
    }
    
    window-rule {
        match app-id="org.pulseaudio.pavucontrol"
        default-column-width { proportion 0.4; }
        open-floating true
    }
    
    window-rule {
        match app-id="com.nextcloud.desktopclient.nextcloud"
        default-column-width { proportion 0.45; }
        open-floating true
    }
    
    window-rule {
        match app-id="^blueman-manager$"
        default-column-width { proportion 0.35; }
        open-floating true
    }
    
    window-rule {
        match app-id="^nm-connection-editor$"
        default-column-width { proportion 0.4; }
        open-floating true
    }
    
    window-rule {
        match app-id="^openrgb$"
        default-column-width { proportion 0.5; }
        open-floating true
    }
    
    window-rule {
        match app-id="^org.coolercontrol.CoolerControl$"
        default-column-width { proportion 0.45; }
        open-floating true
    }
    
    window-rule {
        match app-id="Mullvad VPN"
        open-floating true
    }
    
    window-rule {
        match title="^Incrustation vidéo$"
        open-floating true
        default-column-width { proportion 0.35; }
    }
    
    window-rule {
        match app-id="org.gnome.Calculator"
        open-floating true
        default-column-width { proportion 0.25; }
    }
    
    window-rule {
        match app-id="gcr-prompter"
        open-floating true
    }
    
    window-rule {
        match title="^Steam Guard$"
        open-floating true
    }
    
    window-rule {
        match title="^Paramètres Steam$"
        open-floating true
    }
    
    window-rule {
        match title="^Liste de contacts$"
        open-floating true
    }
    
    window-rule {
        match app-id="^steam_app_"
        open-fullscreen true
    }
    
    window-rule {
        match app-id="^wine$"
        open-fullscreen true
    }
    
    window-rule {
        match app-id="^lutris$"
        open-fullscreen true
    }
    
    window-rule {
        match app-id="^minecraft-launcher$"
        open-fullscreen true
    }
    
    window-rule {
        match title="^Minecraft.*$"
        open-fullscreen true
    }
    
    binds {
        Mod+Q { spawn "kitty"; }
        Mod+C { close-window; }
        Mod+E { spawn "kitty" "-e" "btop"; }
        Mod+T { spawn "thunar"; }
        Mod+G { spawn "kitty" "-e" "lf"; }
        Mod+F { spawn "firefox"; }
        Mod+Shift+F { spawn "firefox" "--private-window"; }
        Mod+R { spawn "sh" "-c" "pgrep wofi >/dev/null 2>&1 && killall wofi || wofi --location=top -y 15"; }
        Mod+A { spawn "sh" "-c" "pgrep wlogout >/dev/null 2>&1 && killall wlogout || wlogout"; }
        Mod+V { toggle-window-floating; }
        Mod+B { fullscreen-window; }
        
        Mod+P { set-column-width "-10%"; }
        Mod+J { set-column-width "+10%"; }
        
        Mod+Left { focus-column-left; }
        Mod+Right { focus-column-right; }
        Mod+Up { focus-window-up; }
        Mod+Down { focus-window-down; }
        Mod+H { focus-column-left; }
        Mod+L { focus-column-right; }
        Mod+K { focus-window-up; }
        
        Mod+Shift+Left { move-column-left; }
        Mod+Shift+Right { move-column-right; }
        Mod+Shift+Up { move-window-up; }
        Mod+Shift+Down { move-window-down; }
        Mod+Shift+H { move-column-left; }
        Mod+Shift+L { move-column-right; }
        Mod+Shift+K { move-window-up; }
        
        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        
        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }
        Mod+Shift+6 { move-column-to-workspace 6; }
        Mod+Shift+7 { move-column-to-workspace 7; }
        
        Mod+S { focus-workspace "magic"; }
        Mod+Shift+S { move-column-to-workspace "magic"; }
        
        Mod+WheelScrollDown { focus-workspace-down; }
        Mod+WheelScrollUp { focus-workspace-up; }
        Mod+WheelScrollRight { focus-workspace-down; }
        Mod+WheelScrollLeft { focus-workspace-up; }
        
        XF86AudioMute { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
        XF86AudioRaiseVolume { spawn "sh" "-c" "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"; }
        XF86AudioLowerVolume { spawn "sh" "-c" "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"; }
        
        XF86AudioPlay { spawn "playerctl" "play-pause"; }
        XF86AudioPause { spawn "playerctl" "play-pause"; }
        XF86AudioNext { spawn "playerctl" "next"; }
        XF86AudioPrev { spawn "playerctl" "previous"; }
        
        XF86MonBrightnessDown { spawn "brightnessctl" "set" "5%-"; }
        XF86MonBrightnessUp { spawn "brightnessctl" "set" "+5%"; }
        
        XF86AudioMedia { spawn "hyprlock"; }
        
        Print { spawn "sh" "-c" "grim -g \"$(slurp)\" - | swappy -f -"; }
        
        Ctrl+Alt+V { spawn "sh" "-c" "cliphist list | wofi --dmenu | cliphist decode | wl-copy"; }
        
        Mod+Shift+E { quit; }
    }
  '';
}
