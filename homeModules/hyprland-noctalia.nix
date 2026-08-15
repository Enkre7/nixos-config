{ config, lib, pkgs, inputs, ... }:
let
  stylix = config.lib.stylix.colors;
  inline = lib.generators.mkLuaInline;
  startupScript = pkgs.writeShellScriptBin "start" ''
    eval $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
    export SSH_AUTH_SOCK

    ${pkgs.networkmanagerapplet}/bin/nm-applet &
    ${pkgs.blueman}/bin/blueman-applet &
    ${pkgs.udiskie}/bin/udiskie &
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
    systemd.enable = false;
    configType = "lua";
    settings = {
      monitor = {
        output = "";
        mode = "preferred";
        position = "auto";
        scale = 1.6;
      };

      config = {
        xwayland.force_zero_scaling = true;

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
          active_opacity = 1.0;
          inactive_opacity = 1.0;
          blur = {
            enabled = true;
            size = 7;
            passes = 1;
            vibrancy = 0.1696;
            popups = true;
          };
        };

        animations.enabled = true;

        dwindle.preserve_split = true;

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
      };

      curve = [
        { _args = [ "myBezier" { type = "bezier"; points = [ [ 0.05 0.9 ] [ 0.1 1.05 ] ]; } ]; }
      ];

      animation = [
        { leaf = "windows"; enabled = true; speed = 7; bezier = "myBezier"; }
        { leaf = "windowsOut"; enabled = true; speed = 7; bezier = "default"; style = "popin 80%"; }
        { leaf = "border"; enabled = true; speed = 10; bezier = "default"; }
        { leaf = "borderangle"; enabled = true; speed = 8; bezier = "default"; }
        { leaf = "fade"; enabled = true; speed = 7; bezier = "default"; }
        { leaf = "workspaces"; enabled = true; speed = 6; bezier = "default"; }
        { leaf = "layers"; enabled = false; }
      ];

      on = {
        _args = [
          "hyprland.start"
          (inline ''function()
  hl.exec_cmd("${startupScript}/bin/start")
end'')
        ];
      };

      bind = [
        { _args = [ "SUPER + A" (inline ''hl.dsp.exec_cmd("noctalia msg panel-toggle session")'') ]; }
        { _args = [ "SUPER + Q" (inline ''hl.dsp.exec_cmd("kitty")'') ]; }
        { _args = [ "SUPER + C" (inline "hl.dsp.window.close()") ]; }
        { _args = [ "SUPER + E" (inline ''hl.dsp.exec_cmd("kitty -e btop")'') ]; }
        { _args = [ "SUPER + T" (inline ''hl.dsp.exec_cmd("thunar")'') ]; }
        { _args = [ "SUPER + G" (inline ''hl.dsp.exec_cmd("kitty -e lf")'') ]; }
        { _args = [ "SUPER + V" (inline ''hl.dsp.window.float({ action = "toggle" })'') ]; }
        { _args = [ "SUPER + R" (inline ''hl.dsp.exec_cmd("noctalia msg panel-toggle launcher")'') ]; }
        { _args = [ "SUPER + N" (inline ''hl.dsp.exec_cmd("noctalia msg panel-toggle control-center")'') ]; }
        { _args = [ "SUPER + L" (inline ''hl.dsp.exec_cmd("noctalia msg session lock")'') ]; }
        { _args = [ "SUPER + P" (inline "hl.dsp.window.pseudo()") ]; }
        { _args = [ "SUPER + J" (inline ''hl.dsp.layout("togglesplit")'') ]; }
        { _args = [ "SUPER + F" (inline ''hl.dsp.exec_cmd("firefox")'') ]; }
        { _args = [ "SUPER + B" (inline "hl.dsp.window.fullscreen()") ]; }
        { _args = [ "SUPER + SHIFT + F" (inline ''hl.dsp.exec_cmd("firefox --private-window")'') ]; }
        { _args = [ "SUPER + left" (inline ''hl.dsp.focus({ direction = "left" })'') ]; }
        { _args = [ "SUPER + right" (inline ''hl.dsp.focus({ direction = "right" })'') ]; }
        { _args = [ "SUPER + up" (inline ''hl.dsp.focus({ direction = "up" })'') ]; }
        { _args = [ "SUPER + down" (inline ''hl.dsp.focus({ direction = "down" })'') ]; }
        { _args = [ "SUPER + code:10" (inline "hl.dsp.focus({ workspace = 1 })") ]; }
        { _args = [ "SUPER + code:11" (inline "hl.dsp.focus({ workspace = 2 })") ]; }
        { _args = [ "SUPER + code:12" (inline "hl.dsp.focus({ workspace = 3 })") ]; }
        { _args = [ "SUPER + code:13" (inline "hl.dsp.focus({ workspace = 4 })") ]; }
        { _args = [ "SUPER + code:14" (inline "hl.dsp.focus({ workspace = 5 })") ]; }
        { _args = [ "SUPER + code:15" (inline "hl.dsp.focus({ workspace = 6 })") ]; }
        { _args = [ "SUPER + code:16" (inline "hl.dsp.focus({ workspace = 7 })") ]; }
        { _args = [ "SUPER + code:17" (inline "hl.dsp.focus({ workspace = 8 })") ]; }
        { _args = [ "SUPER + code:18" (inline "hl.dsp.focus({ workspace = 9 })") ]; }
        { _args = [ "SUPER + code:19" (inline "hl.dsp.focus({ workspace = 10 })") ]; }
        { _args = [ "SUPER + SHIFT + code:10" (inline "hl.dsp.window.move({ workspace = 1 })") ]; }
        { _args = [ "SUPER + SHIFT + code:11" (inline "hl.dsp.window.move({ workspace = 2 })") ]; }
        { _args = [ "SUPER + SHIFT + code:12" (inline "hl.dsp.window.move({ workspace = 3 })") ]; }
        { _args = [ "SUPER + SHIFT + code:13" (inline "hl.dsp.window.move({ workspace = 4 })") ]; }
        { _args = [ "SUPER + SHIFT + code:14" (inline "hl.dsp.window.move({ workspace = 5 })") ]; }
        { _args = [ "SUPER + SHIFT + code:15" (inline "hl.dsp.window.move({ workspace = 6 })") ]; }
        { _args = [ "SUPER + SHIFT + code:16" (inline "hl.dsp.window.move({ workspace = 7 })") ]; }
        { _args = [ "SUPER + SHIFT + code:17" (inline "hl.dsp.window.move({ workspace = 8 })") ]; }
        { _args = [ "SUPER + SHIFT + code:18" (inline "hl.dsp.window.move({ workspace = 9 })") ]; }
        { _args = [ "SUPER + SHIFT + code:19" (inline "hl.dsp.window.move({ workspace = 10 })") ]; }
        { _args = [ "SUPER + S" (inline ''hl.dsp.workspace.toggle_special("magic")'') ]; }
        { _args = [ "SUPER + SHIFT + S" (inline ''hl.dsp.window.move({ workspace = "special:magic" })'') ]; }
        { _args = [ "SUPER + mouse_down" (inline ''hl.dsp.focus({ workspace = "e+1" })'') ]; }
        { _args = [ "SUPER + mouse_up" (inline ''hl.dsp.focus({ workspace = "e-1" })'') ]; }
        { _args = [ "XF86AudioMute" (inline ''hl.dsp.exec_cmd("noctalia msg volume-mute")'') ]; }
        { _args = [ "XF86AudioPlay" (inline ''hl.dsp.exec_cmd("playerctl play-pause")'') ]; }
        { _args = [ "XF86AudioPause" (inline ''hl.dsp.exec_cmd("playerctl play-pause")'') ]; }
        { _args = [ "XF86AudioNext" (inline ''hl.dsp.exec_cmd("playerctl next")'') ]; }
        { _args = [ "XF86AudioPrev" (inline ''hl.dsp.exec_cmd("playerctl previous")'') ]; }
        { _args = [ "XF86AudioMedia" (inline ''hl.dsp.exec_cmd("noctalia msg session lock")'') ]; }
        { _args = [ "Print" (inline ''hl.dsp.exec_cmd("noctalia msg screenshot-region")'') ]; }
        { _args = [ "CTRL + ALT + V" (inline ''hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard")'') ]; }
        { _args = [ "SUPER + mouse:272" (inline "hl.dsp.window.drag()") { mouse = true; } ]; }
        { _args = [ "SUPER + mouse:273" (inline "hl.dsp.window.resize()") { mouse = true; } ]; }
        { _args = [ "XF86AudioRaiseVolume" (inline ''hl.dsp.exec_cmd("noctalia msg volume-up")'') { repeating = true; } ]; }
        { _args = [ "XF86AudioLowerVolume" (inline ''hl.dsp.exec_cmd("noctalia msg volume-down")'') { repeating = true; } ]; }
        { _args = [ "XF86MonBrightnessDown" (inline ''hl.dsp.exec_cmd("noctalia msg brightness-down")'') { repeating = true; } ]; }
        { _args = [ "XF86MonBrightnessUp" (inline ''hl.dsp.exec_cmd("noctalia msg brightness-up")'') { repeating = true; } ]; }
        { _args = [ "switch:on:Lid Switch" (inline ''hl.dsp.exec_cmd("hyprctl dispatch dpms off")'') { locked = true; } ]; }
        { _args = [ "switch:off:Lid Switch" (inline ''hl.dsp.exec_cmd("hyprctl dispatch dpms on")'') { locked = true; } ]; }
      ];

      window_rule = [
        { match.class = "^(org\\.pulseaudio\\.pavucontrol)$"; float = true; size = [ 800 600 ]; center = true; }
        { match.class = "^(com\\.nextcloud\\.desktopclient\\.nextcloud)$"; float = true; size = [ 873 586 ]; center = true; }
        { match.class = "^(\\.blueman-manager-wrapped)$"; float = true; size = [ 700 500 ]; center = true; }
        { match.class = "^(thunar)$"; float = true; size = [ 1000 700 ]; center = true; }
        { match.class = "^(xdg-desktop-portal-gtk)$"; float = true; size = [ 1000 700 ]; center = true; }
        { match.class = "^(nm-connection-editor)$"; float = true; size = [ 800 600 ]; center = true; }
        { match.class = "^(nm-applet)$"; float = true; size = [ 400 300 ]; center = true; }
        { match.class = "^(openrgb)$"; float = true; size = [ 1000 700 ]; center = true; }
        { match.class = "^(org\\.coolercontrol\\.CoolerControl)$"; float = true; size = [ 908 678 ]; center = true; }
        { match.class = "^(Mullvad VPN)$"; float = true; size = [ 320 568 ]; center = true; }
        { match.title = "^(Proton VPN)$"; float = true; size = [ 403 600 ]; center = true; pin = true; }
        { match.class = "^(org\\.kde\\.kdeconnect\\.app)$"; float = true; size = [ 762 687 ]; center = true; }
        { match.title = "^(Incrustation vidéo)$"; float = true; pin = true; size = [ "35%" "35%" ]; move = [ "64%" "4%" ]; no_blur = true; no_shadow = true; no_anim = true; }
        { match.title = "^(Suppression des cookies.*)$"; float = true; size = [ 490 154 ]; center = true; }
        { match.title = "^(Extension.*)$"; float = true; size = [ 1000 700 ]; center = true; }
        { match.class = "^(org\\.gnome\\.FileRoller)$"; float = true; size = [ 1000 700 ]; center = true; }
        { match.class = "^(org\\.gnome\\.Calculator)$"; float = true; size = [ 360 616 ]; }
        { match.class = "^(gcr-prompter)$"; float = true; center = true; pin = true; }
        { match.class = "^(disk-monitor)$"; float = true; size = [ 1200 800 ]; center = true; }
        { match.class = "^(system-monitor)$"; float = true; size = [ 1200 800 ]; center = true; }
        { match.class = "^(virt-manager)$"; float = true; size = [ 800 600 ]; center = true; }
        { match.class = "^(system-config-printer)$"; float = true; size = [ 700 500 ]; center = true; }
        { match.class = "^(org\\.prismlauncher\\.PrismLauncher)$"; float = true; size = [ 1100 700 ]; center = true; }
        { match.class = "^(vesktop)$"; float = true; size = [ 900 600 ]; center = true; }
        { match.class = "^(mpv)$"; idle_inhibit = "fullscreen"; }
        { match.title = "^(Steam Guard|Paramètres Steam|Liste de contacts|Offres spéciales)$"; float = true; }
        { match.title = "^(Liste de contacts)$"; size = [ 480 480 ]; center = true; }
        { match.class = "^(steam)$"; center = true; }
        { match.class = "^(steam_app_.+)$"; fullscreen = true; immediate = true; idle_inhibit = "fullscreen"; }
        { match.class = "^(wine|lutris)$"; fullscreen = true; immediate = true; idle_inhibit = "fullscreen"; workspace = "special:games"; }
        { match.class = "^(minecraft-launcher|gamemoderun|heroic|legendary|bottles|retroarch|dolphin-emu|pcsx2-qt|rpcs3|yuzu|citra|hl2_linux|csgo_linux64|dota2)$"; fullscreen = true; }
        { match.class = "^(codium)$"; opacity = "0.90 0.85"; }
      ];
    };
  };
}
