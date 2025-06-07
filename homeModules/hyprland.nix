{ config, lib, pkgs, inputs, ... }:
let
  stylix = config.lib.stylix.colors;
  startupScript = pkgs.writeShellScriptBin "start" ''
    # Start of SSH agent for gnome-keyrings
    eval $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
    export SSH_AUTH_SOCK

    ${pkgs.waybar}/bin/waybar &    
    ${pkgs.mako}/bin/mako &
    ${pkgs.networkmanagerapplet}/bin/nm-applet &
    ${pkgs.blueman}/bin/blueman-applet &
    ${pkgs.udiskie}/bin/udiskie &
    ${pkgs.gammastep}/bin/gammastep &
    thunar --daemon &
    #${pkgs.swww}/bin/swww-daemon &
    sleep 0.1 &
    #${pkgs.swww}/bin/swww img config.wallpaper &

    ${pkgs.vesktop}/bin/vesktop --start-minimized &
    ${pkgs.mullvad-vpn}/bin/mullvad-vpn &
    #${pkgs.nextcloud-client}/bin/nextcloud --background &

    wl-paste --watch cliphist store &

    coolercontrol &     
    openrgb --startminimized --server -m static -c 00FF00 -b 100 &   
  '';
in
{
  imports = [ inputs.hyprland.homeManagerModules.default ]; 
 
  wayland.windowManager.hyprland = {
    enable = true;    
    settings = {
      monitor = [
        ",preferred,auto,1.6"
      ];
      xwayland.force_zero_scaling = true;

      "$mainMod" = "SUPER";
      "$terminal" = "kitty";
      "$fileManager" = "thunar";
      "$browser" = "floorp";
      "$browserPrivate" = "floorp --private-window";
      "$termFileManager" = "lf";
      "$menu" = "pgrep wofi >/dev/null 2>&1 && killall wofi || wofi --location=top -y 15";
      "$systman" = "btop";
      "$screenshot" = "grim -g \"$(slurp)\" - | swappy -f -";
      "$clipboard" = "cliphist list | wofi --dmenu | cliphist decode | wl-copy";
      "$powermanager" = "pgrep wlogout >/dev/null 2>&1 && killall wlogout || wlogout";
      "$lockscreen" = "hyprlock";

      exec-once = ''${startupScript}/bin/start'';
      
      general = { 
        gaps_in = 3;
        gaps_out = 5;
        border_size = 2;
        "col.active_border" = lib.mkForce "rgb(${stylix.base0E}) rgb(${stylix.base0A}) 45deg";
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

      gestures.workspace_swipe = true;

      bind = [
        "$mainMod, A, exec, $powermanager"
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
	# Move active window to a workspace with mainMod + SHIFT + [0-7]
	"$mainMod SHIFT, code:10, movetoworkspace, 1"
	"$mainMod SHIFT, code:11, movetoworkspace, 2"
	"$mainMod SHIFT, code:12, movetoworkspace, 3"
	"$mainMod SHIFT, code:13, movetoworkspace, 4"
	"$mainMod SHIFT, code:14, movetoworkspace, 5"
        "$mainMod SHIFT, code:15, movetoworkspace, 6"
        "$mainMod SHIFT, code:16, movetoworkspace, 7"
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
        # Network Manager
        "float, class:^(nm-.*)$"

        # Pavucontrol
        "float, class:(pavucontrol)"
        "center, class:(pavucontrol)"
        "pin, class:(pavucontrol)"
        "size 955 472, class:(pavucontrol)"

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

        # Mullvad VPN
        "pin, class:(Mullvad VPN)"
        "rounding 10, class:(Mullvad VPN)"
        "noborder, class:(Mullvad VPN)"

        # Blueman manager
        "float, class:(.blueman-manager-wrapped)"
        "size 654 428, class:(.blueman-manager-wrapped)"
        "center, class:(.blueman-manager-wrapped)"

        # Btop
        "float, class:(kitty), title:(btop)"

	# Firefox browsers
        "float, title:^(Incrustation vidéo)$"
        "pin, title:^(Incrustation vidéo)$"
	"keepaspectratio, title:^(Incrustation vidéo)$"
	"noborder, title:^(Incrustation vidéo)$"
	"size 35% 35%, title:^(Incrustation vidéo)$"
        "move 911 50, title:^(Incrustation vidéo)$"
        "size 490 154, title:^(Suppression des cookies.*)$"
        "float, title:^(Extension:.*)$"

        # Nexctcloud
        "pin, class:(Nextcloud)"
        "rounding 10, class:(Nextcloud)"
        "noborder, class:(Nextcloud)"
        "float, class:(Nextcloud)"
        "center, class:(Nextcloud)"
        "size 800 500, class:(Nextcloud)"

        # Minecraft
        "fullscreen, title:^(Minecraft)(.*)$"

        # Gnome calculator
        "float, class:(org.gnome.Calculator)" # All modes
        #"size 670 700, class:(org.gnome.Calculator)" # Basic mode
        "size 360 616, class:(org.gnome.Calculator)"
        "move 1043 52, class:(org.gnome.Calculator)"

        # Keyring manager
        "dimaround, class:(gcr-prompter)"
        "pin, class:(gcr-prompter)"
      ];
    };
  };
}
