{ config, lib, pkgs, inputs, ... }:
let
  stylix = config.lib.stylix.colors;
  startupScript = pkgs.writeShellScriptBin "start" ''
    # Start of SSH agent for gnome-keyrings
    eval $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh) &
    
    #${pkgs.plasma5Packages.kdeconnect-kde}/bin/kdeconnect-app &
    ${pkgs.mako}/bin/mako &
    ${pkgs.networkmanagerapplet}/bin/nm-applet &
    ${pkgs.blueman}/bin/blueman-applet &
    ${pkgs.udiskie}/bin/udiskie &
    ${pkgs.gammastep}/bin/gammastep &
    ${pkgs.swww}/bin/swww-daemon &
    sleep 0.1
    ${pkgs.swww}/bin/swww img config.wallpaper &

    ${pkgs.webcord}/bin/webcord -m &
    ${pkgs.mullvad-vpn}/bin/mullvad-vpn &
    ${pkgs.nextcloud-client}/bin/nextcloud --background &
  '';
in
{
 imports = [ inputs.hyprland.homeManagerModules.default ]; 
 
  wayland.windowManager.hyprland = {
    enable = true;    
    settings = {
      monitor = "eDP-1,highres,auto,auto";
      xwayland.force_zero_scaling = false;

      "$terminal" = "kitty";
      "$fileManager" = "thunar";
      "$menu" = "wofi";
      "$systman" = "btop";
      "$screenshot" = "grim -g \"$(slurp)\" - | swappy -f -";
       
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
        drop_shadow = true;
        shadow_range = 5;
        shadow_render_power = 3;
        "col.shadow" = lib.mkForce "rgb(${stylix.base00})";
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
        touchpad = {
          natural_scroll = false;
          disable_while_typing = false;
        };
      };

      gestures.workspace_swipe = true;

      device = {
        name = "epic-mouse-v1";
        sensitivity = "-0.5";
      };

      "$mainMod" = "SUPER"; # Sets "Windows" key as main modifier

      bind = [
        "$mainMod, A, exec, wlogout"
        "$mainMod, Q, exec, $terminal"
        "$mainMod, C, killactive,"
        "$mainMod, E, exec, $systman"
        "$mainMod, T, exec, $fileManager"
        "$mainMod, V, togglefloating,"
        "$mainMod, R, exec, $menu"
        "$mainMod, P, pseudo," # dwindle
        "$mainMod, J, togglesplit," # dwindle
        "$mainMod, F, exec, firefox"
        # Move focus with mainMod + arrow keys
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
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
	# Scroll through existing workspaces with mainMod + scroll
	"$mainMod, mouse_down, workspace, e+1"
	"$mainMod, mouse_up, workspace, e-1"
	# Sound
	",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
	",XF86AudioPlay, exec, playerctl play-pause"
	",XF86AudioPause, exec, playerctl play-pause"
	",XF86AudioNext, exec, playerctl next"
	",XF86AudioPrev, exec, playerctl previous"
        # Lock Session
        ",XF86AudioMedia, exec, hyprlock"
        # Screenshot
        ",Print, exec, $screenshot"
      ];

      binde = [
	# Sound
	",XF86AudioRaiseVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 | wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
	",XF86AudioLowerVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 | wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"
	# Screen Brightness
	",XF86MonBrightnessDown, exec, brightnessctl set 10%-"
	",XF86MonBrightnessUP, exec, brightnessctl set 10%+"
      ];
      
      bindm = [
	# Move/resize windows with mainMod + LMB/RMB and dragging
	"$mainMod, mouse:272, movewindow"
	"$mainMod, mouse:273, resizewindow"
      ];
      
      # To get windows's names: hyprctl clients
      windowrule = [
	"float, ^(nm-connection-editor)$"
        "float, ^(nm-applet)$"
        # Bitwarden extension
        "float, ^(Bitwarden)$"
        "size 370 881, ^(Bitwarden)$"
      ];

      "$firefox" = "class:(firefox)";

      windowrulev2 = [
        # Pavucontrol
        "float, class:(pavucontrol)"
        "center, class:(pavucontrol)"
        "size 829 325, class:(pavucontrol)"
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
        # Mullvad VPN
        "pin, class:(Mullvad VPN)"
        "rounding 10, class:(Mullvad VPN)"
        "noborder, class:(Mullvad VPN)"
        # Blueman manager
        "float, class:(.blueman-manager-wrapped)"
        "size 654 428, class:(.blueman-manager-wrapped)"
        "center, class:(.blueman-manager-wrapped)"
	# Firefox
        "float, class:(firefox), title:^(Incrustation vidéo)$"
        "pin, class:(firefox), title:^(Incrustation vidéo)$"
	"keepaspectratio, class:(firefox), title:^(Incrustation vidéo)$"
	"noborder, class:(firefox), title:^(Incrustation vidéo)$"
	"size 35% 35%, class:(firefox), title:^(Incrustation vidéo)$"
        "move 911 50, class:(firefox), title:^(Incrustation vidéo)$"
        "size 490 154, class:(firefox), title:^(Suppression des cookies.*)$"
        # Nexctcloud
        "pin, class:(com.nextcloud.desktopclient.nextcloud)"
        "rounding 10, class:(com.nextcloud.desktopclient.nextcloud)"
        "noborder, class:(com.nextcloud.desktopclient.nextcloud)"
        "float, class:(com.nextcloud.desktopclient.nextcloud)"
        "center, class:(com.nextcloud.desktopclient.nextcloud)"
        "size 800 500, class:(com.nextcloud.desktopclient.nextcloud)"
        # Minecraft
        "fullscreen, title:^(Minecraft)(.*)$"
        # Gnome calculator
        "float, class:(org.gnome.Calculator)" # All modes
        #"size 670 700, class:(org.gnome.Calculator)" # Basic mode
        "size 345 492, class:(org.gnome.Calculator)"
        "move 1058 52, class:(org.gnome.Calculator)"
        # keyring manager
        "dimaround, class:(gcr-prompter)"
        "pin, class:(gcr-prompter)"
      ];
    };
  };
}
