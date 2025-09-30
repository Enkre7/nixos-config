{ config, pkgs, lib, ... }:

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
        height = 35;
        spacing = 0;
        margin-top = 8;
        margin-left = 8;
        margin-right = 8;
        
        modules-left = mkIf (workspacesModule != null) [
          workspacesModule
        ] ++ optional (windowModule != null) windowModule;
        
        modules-center = [ "clock" ];
        
        modules-right = [
          "cpu"
          "memory"
        ] ++ optional config.isLaptop "battery"
          ++ [
          "pulseaudio"
          "network"
          "custom/notification"
          "tray"
        ];

        "hyprland/workspaces" = mkIf isHyprland {
          format = "{icon}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
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
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            "urgent" = "";
            "focused" = "";
            "default" = "";
          };
        };

        "${windowModule}" = mkIf (windowModule != null) {
          format = "{}";
          max-length = 60;
          separate-outputs = true;
        };

        clock = {
          interval = 1;
          format = " {:%H:%M}";
          format-alt = " {:%A %d %B}";
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
          on-click = "kitty --class='system-monitor' --hold -e btop";
        };

        memory = {
          interval = 5;
          format = " {percentage}%";
          tooltip-format = "RAM: {used:0.1f}G / {total:0.1f}G";
          on-click = "kitty --class='system-monitor' --hold -e btop";
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
        min-height: 0;
      }

      window#waybar {
        background: ${stylix.base00};
        border-bottom: 2px solid ${stylix.base0D};
      }

      #workspaces {
        background: transparent;
        padding: 0 5px;
      }

      #workspaces button {
        color: ${stylix.base04};
        background: transparent;
        padding: 5px 12px;
        margin: 0 2px;
        border-radius: 0;
        border-bottom: 2px solid transparent;
        transition: all 0.2s ease;
      }

      #workspaces button:hover {
        color: ${stylix.base05};
        border-bottom: 2px solid ${stylix.base0D};
      }

      #workspaces button.active,
      #workspaces button.focused {
        color: ${stylix.base0D};
        border-bottom: 2px solid ${stylix.base0D};
      }

      #workspaces button.urgent {
        color: ${stylix.base08};
        border-bottom: 2px solid ${stylix.base08};
      }

      #window {
        color: ${stylix.base05};
        padding: 0 15px;
      }

      #clock {
        color: ${stylix.base0E};
        padding: 0 15px;
        font-weight: bold;
      }

      #cpu {
        color: ${stylix.base0C};
        padding: 0 12px;
        border-left: 1px solid ${stylix.base02};
      }

      #memory {
        color: ${stylix.base0B};
        padding: 0 12px;
        border-left: 1px solid ${stylix.base02};
      }

      #battery {
        color: ${stylix.base0A};
        padding: 0 12px;
        border-left: 1px solid ${stylix.base02};
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
        padding: 0 12px;
        border-left: 1px solid ${stylix.base02};
      }

      #network.disconnected {
        color: ${stylix.base08};
      }

      #pulseaudio {
        color: ${stylix.base0E};
        padding: 0 12px;
        border-left: 1px solid ${stylix.base02};
      }

      #pulseaudio.muted {
        color: ${stylix.base03};
      }

      #custom-notification {
        padding: 0 12px;
        color: ${stylix.base05};
        border-left: 1px solid ${stylix.base02};
      }

      #tray {
        padding: 0 12px;
        border-left: 1px solid ${stylix.base02};
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: ${stylix.base08};
      }

      #cpu:hover,
      #memory:hover,
      #battery:hover,
      #network:hover,
      #pulseaudio:hover,
      #clock:hover,
      #custom-notification:hover {
        background: ${stylix.base01};
      }

      tooltip {
        background: ${stylix.base00};
        border: 1px solid ${stylix.base0D};
        border-radius: 4px;
        padding: 8px;
      }

      tooltip label {
        color: ${stylix.base05};
      }
    '';
  };
}
