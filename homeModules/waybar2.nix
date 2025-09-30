{
  config,
  pkgs,
  lib,
  ...
}:

let
  stylix = config.lib.stylix.colors.withHashtag;
  
  isHyprland = config.wayland.windowManager.hyprland.enable or false;
  isSway = config.wayland.windowManager.sway.enable or false;
  isNiri = builtins.pathExists "${config.xdg.configHome}/niri/config.kdl";
  
  workspacesModule = 
    if isHyprland then "hyprland/workspaces"
    else if isSway then "sway/workspaces"
    else if isNiri then "niri/workspaces"
    else null;
    
  windowModule =
    if isHyprland then "hyprland/window"
    else if isSway then "sway/window"
    else if isNiri then "niri/window"
    else null;
in
with lib;
{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    
    settings = [
      {
        layer = "top";
        position = "top";
        height = 40;
        spacing = 8;
        margin-top = 8;
        margin-left = 12;
        margin-right = 12;
        
        modules-left = mkIf (workspacesModule != null) [
          workspacesModule
        ] ++ optional (windowModule != null) windowModule;
        
        modules-center = [ "clock" ];
        
        modules-right = [
          "pulseaudio"
          "network"
          "cpu"
          "memory"
        ] ++ optional config.isLaptop "battery"
          ++ [ "custom/notification" "tray" ];

        "hyprland/workspaces" = mkIf isHyprland {
          format = "{icon}";
          format-icons = {
            "1" = "一";
            "2" = "二";
            "3" = "三";
            "4" = "四";
            "5" = "五";
            "active" = "";
            "default" = "";
          };
          persistent-workspaces = {
            "*" = 5;
          };
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
        };

        "sway/workspaces" = mkIf isSway {
          format = "{icon}";
          format-icons = {
            "1" = "一";
            "2" = "二";
            "3" = "三";
            "4" = "四";
            "5" = "五";
            "urgent" = "";
            "focused" = "";
            "default" = "";
          };
        };

        "${windowModule}" = mkIf (windowModule != null) {
          format = "{}";
          max-length = 50;
          separate-outputs = true;
        };

        clock = {
          interval = 1;
          format = "{:%H:%M}";
          format-alt = "{:%A, %d %B %Y}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='${stylix.base09}'><b>{}</b></span>";
              days = "<span color='${stylix.base05}'><b>{}</b></span>";
              weeks = "<span color='${stylix.base0C}'><b>W{}</b></span>";
              weekdays = "<span color='${stylix.base0A}'><b>{}</b></span>";
              today = "<span color='${stylix.base08}'><b><u>{}</u></b></span>";
            };
          };
        };

        cpu = {
          interval = 2;
          format = " {usage}%";
          tooltip = true;
        };

        memory = {
          interval = 5;
          format = " {percentage}%";
          tooltip-format = "RAM: {used:0.1f}G / {total:0.1f}G";
        };

        battery = mkIf config.isLaptop {
          interval = 5;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-icons = [ "" "" "" "" "" ];
        };

        network = {
          interval = 3;
          format-wifi = " {signalStrength}%";
          format-ethernet = "";
          format-disconnected = "󰤮";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}";
          tooltip-format-wifi = "{essid} ({signalStrength}%)";
          on-click = "nm-connection-editor";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = " ";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" ];
          };
          on-click = "pavucontrol";
        };

        "custom/notification" = {
          tooltip = false;
          format = "{icon} {}";
          format-icons = {
            notification = "<span foreground='${stylix.base08}'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='${stylix.base08}'><sup></sup></span>";
            dnd-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t";
          escape = true;
        };

        tray = {
          icon-size = 18;
          spacing = 10;
        };
      }
    ];

    style = ''
      * {
        font-family: ${config.stylix.fonts.monospace.name};
        font-size: 13px;
        font-weight: 600;
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      window#waybar {
        background: transparent;
      }

      .modules-left,
      .modules-center,
      .modules-right {
        background: ${stylix.base01}cc;
        border-radius: 12px;
        padding: 4px 8px;
        margin: 0 4px;
      }

      .modules-left > * { margin: 0 6px; }
      .modules-center > * { margin: 0 6px; }
      .modules-right > * { margin: 0 6px; }

      #workspaces {
        background: transparent;
      }

      #workspaces button {
        color: ${stylix.base05};
        background: transparent;
        padding: 4px 10px;
        margin: 0 2px;
        border-radius: 8px;
        transition: all 0.3s cubic-bezier(0.55, 0.0, 0.28, 1.682);
      }

      #workspaces button:hover {
        background: ${stylix.base0D}4d;
        color: ${stylix.base0D};
      }

      #workspaces button.active,
      #workspaces button.focused {
        background: ${stylix.base0D};
        color: ${stylix.base00};
      }

      #workspaces button.urgent {
        background: ${stylix.base08};
        color: ${stylix.base00};
      }

      #window {
        color: ${stylix.base05};
        font-weight: 500;
        padding: 0 12px;
      }

      #clock {
        color: ${stylix.base0E};
        padding: 0 12px;
        font-weight: bold;
      }

      #cpu {
        color: ${stylix.base0C};
        padding: 0 10px;
      }

      #memory {
        color: ${stylix.base0B};
        padding: 0 10px;
      }

      #battery {
        color: ${stylix.base0A};
        padding: 0 10px;
      }

      #battery.charging {
        color: ${stylix.base0B};
      }

      #battery.warning:not(.charging) {
        color: ${stylix.base09};
      }

      #battery.critical:not(.charging) {
        color: ${stylix.base08};
        animation: blink 1s linear infinite;
      }

      @keyframes blink {
        50% { opacity: 0.5; }
      }

      #network {
        color: ${stylix.base0D};
        padding: 0 10px;
      }

      #network.disconnected {
        color: ${stylix.base08};
      }

      #pulseaudio {
        color: ${stylix.base0E};
        padding: 0 10px;
      }

      #pulseaudio.muted {
        color: ${stylix.base03};
      }

      #custom-notification {
        padding: 0 10px;
        color: ${stylix.base05};
      }

      #tray {
        padding: 0 10px;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: ${stylix.base08};
        border-radius: 8px;
      }

      #cpu:hover,
      #memory:hover,
      #battery:hover,
      #network:hover,
      #pulseaudio:hover,
      #clock:hover,
      #custom-notification:hover {
        background: ${stylix.base02};
        border-radius: 8px;
        transition: all 0.3s ease;
      }

      tooltip {
        background: ${stylix.base00}f2;
        border: 1px solid ${stylix.base03};
        border-radius: 8px;
        padding: 8px;
      }

      tooltip label {
        color: ${stylix.base05};
      }
    '';
  };
}
