{
  config,
  pkgs,
  lib,
  ...
}:

let
  stylix = config.lib.stylix.colors.withHashtag;
  betterTransition = "all 0.3s cubic-bezier(.55,-0.68,.48,1.682)";
  
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
        margin-top = 5;
        margin-left = 10;
        margin-right = 10;
        
        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "pulseaudio"
          "battery"
          "custom/notification"
          "tray"
        ];

        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          format-icons = {
            "1" = "󰲠";
            "2" = "󰲢";
            "3" = "󰲤";
            "4" = "󰲦";
            "5" = "󰲨";
            "6" = "󰲪";
            "7" = "󰲬";
            "8" = "󰲮";
            "9" = "󰲰";
            default = "○";
            active = "●";
            urgent = "󰀧";
          };
          persistent-workspaces = {
            "*" = 5;
          };
        };

        "hyprland/window" = {
          format = "{title}";
          max-length = 60;
          separate-outputs = true;
        };

        clock = {
          interval = 1;
          format = "{:%H:%M}";
          format-alt = "{:%A, %d %B %Y}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='${stylix.base09}'><b>{}</b></span>";
              days = "<span color='${stylix.base05}'><b>{}</b></span>";
              weeks = "<span color='${stylix.base0F}'><b>{}</b></span>";
              weekdays = "<span color='${stylix.base0A}'><b>{}</b></span>";
              today = "<span color='${stylix.base08}'><b><u>{}</u></b></span>";
            };
          };
        };

        pulseaudio = {
          format = "<span size='x-large'>{icon}</span> <span size='medium'>{volume}%</span>";
          format-bluetooth = "<span size='x-large'>󰂯</span> <span size='medium'>{volume}%</span>";
          format-bluetooth-muted = "<span size='x-large'>󰂲</span> <span size='medium'>󰝟</span>";
          format-muted = "<span size='x-large'>󰝟</span>";
          format-source = "<span size='x-large'>󰍬</span> <span size='medium'>{volume}%</span>";
          format-source-muted = "<span size='x-large'>󰍭</span>";
          format-icons = {
            headphone = "󰋋";
            hands-free = "󰋎";
            headset = "󰋎";
            phone = "󰏲";
            portable = "󰦧";
            car = "󰄋";
            default = ["󰕿" "󰖀" "󰕾"];
          };
          on-click = "pavucontrol";
          on-click-right = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
        };

        battery = {
          interval = 10;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "<span size='x-large'>{icon}</span> <span size='medium'>{capacity}%</span>";
          format-charging = "<span size='x-large'>󰂄</span> <span size='medium'>{capacity}%</span>";
          format-plugged = "<span size='x-large'>󰚥</span> <span size='medium'>{capacity}%</span>";
          format-full = "<span size='x-large'>󰁹</span> <span size='medium'>{capacity}%</span>";
          format-icons = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          tooltip-format = "{time}";
        };

        "custom/notification" = {
          tooltip = false;
          format = "<span size='x-large'>{icon}</span> <span size='medium'>{}</span>";
          format-icons = {
            notification = "<span foreground='${stylix.base08}'>󰍡</span>";
            none = "󰂚";
            dnd-notification = "<span foreground='${stylix.base08}'>󰍡</span>";
            dnd-none = "󱏧";
            inhibited-notification = "<span foreground='${stylix.base08}'>󰍡</span>";
            inhibited-none = "󰂚";
            dnd-inhibited-notification = "<span foreground='${stylix.base08}'>󰍡</span>";
            dnd-inhibited-none = "󱏧";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t";
          escape = true;
        };

        tray = {
          icon-size = 16;
          spacing = 8;
        };
      }
    ];
    
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font Mono";
        font-size: 0.8rem;
        border: none;
        border-radius: 0;
        min-height: 0;
        padding: 0;
        margin: 0;
      }

      window#waybar {
        background: transparent;
        color: ${stylix.base05};
      }

      tooltip {
        background: ${stylix.base00};
        border-radius: 15px;
        border: 2px solid ${stylix.base0D};
        color: ${stylix.base05};
        padding: 8px;
      }

      tooltip label {
        padding: 4px;
      }

      #workspaces {
        background: ${stylix.base01};
        margin: 4px 4px 4px 8px;
        padding: 4px 1rem;
        border-radius: 16px;
      }

      #workspaces button {
        color: ${stylix.base04};
        padding: 4px 8px;
        margin: 0 2px;
        border-radius: 12px;
        background: transparent;
        transition: ${betterTransition};
        font-size: 2.5rem;
      }

      #workspaces button.active {
        color: ${stylix.base0D};
        background: ${stylix.base02};
      }

      #workspaces button.urgent {
        color: ${stylix.base09};
        background: ${stylix.base02};
      }

      #workspaces button:hover {
        color: ${stylix.base0D};
        background: ${stylix.base02};
        transition: ${betterTransition};
      }

      #window {
        background: ${stylix.base01};
        color: ${stylix.base05};
        padding: 8px 1rem;
        margin: 4px 4px;
        border-radius: 16px;
        font-weight: bold;
        font-size: 0.8rem;
      }

      #clock {
        background: ${stylix.base01};
        color: ${stylix.base05};
        padding: 8px 1.5rem;
        margin: 4px;
        border-radius: 16px;
        font-weight: bold;
        font-size: 0.8rem;
      }

      #network {
        background: ${stylix.base01};
        color: ${stylix.base0C};
        padding: 8px 12px;
        margin: 4px 2px;
        border-radius: 16px;
        font-weight: bold;
      }

      #pulseaudio {
        background: ${stylix.base01};
        color: ${stylix.base0A};
        padding: 8px 12px;
        margin: 4px 2px;
        border-radius: 16px;
        font-weight: bold;
      }

      #battery {
        background: ${stylix.base01};
        color: ${stylix.base0B};
        padding: 8px 12px;
        margin: 4px 2px;
        border-radius: 16px;
        font-weight: bold;
      }

      #battery.warning {
        color: ${stylix.base09};
      }

      #battery.critical {
        color: ${stylix.base08};
        animation: blink 0.5s linear infinite alternate;
      }

      #custom-notification {
        background: ${stylix.base01};
        color: ${stylix.base0E};
        padding: 8px 12px;
        margin: 4px 2px;
        border-radius: 16px;
        font-weight: bold;
      }

      #tray {
        background: ${stylix.base01};
        padding: 8px 12px;
        margin: 4px 8px 4px 2px;
        border-radius: 16px;
        font-size: 0.6rem;
      }

      #tray > .passive {
        opacity: 0.8;
      }

      #tray > .needs-attention {
        color: ${stylix.base08};
      }

      @keyframes blink {
        to {
          background-color: ${stylix.base08};
          color: ${stylix.base00};
        }
      }
    '';
  };
}
