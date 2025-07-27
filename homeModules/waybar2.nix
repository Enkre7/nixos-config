{
  config,
  pkgs,
  lib,
  ...
}:

let
  stylix = config.lib.stylix.colors.withHashtag;
  betterTransition = "all 0.3s cubic-bezier(.55,-0.68,.48,1.682)";
  
  useVerticalBar = false;
  
  horizontalConfig = {
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
      "network"
      "custom/notification"
      "tray"
    ];
  };
  
  verticalConfig = {
    layer = "top";
    position = "left";
    height = 400;
    width = 60;
    margin-left = 10;
    margin-top = 10;
    margin-bottom = 10;
    
    modules-center = [
      "hyprland/workspaces"
      "custom/separator"
      "network"
      "pulseaudio"
      "battery"
      "custom/separator"
      "custom/calendar-icon"
      "clock"
      "clock#date"
      "custom/time-icon"
      "clock#time"
    ];
  };
  
  commonModules = {
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
      max-length = 50;
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

    "clock#date" = {
      format = "{:%d}";
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
    };

    "clock#time" = {
      format = "{:%H\n%M}";
    };

    "custom/calendar-icon" = {
      format = "󰃭";
      tooltip = false;
    };

    "custom/time-icon" = {
      format = "󰥔";
      tooltip = false;
    };

    "custom/separator" = {
      format = "│";
      tooltip = false;
    };

    network = {
      format-wifi = "󰤨";
      format-ethernet = "󰈀";
      format-linked = "󰤨";
      format-disconnected = "󰤭";
      tooltip-format-wifi = "{essid} ({signalStrength}%)";
      tooltip-format-ethernet = "{ipaddr}/{cidr}";
      tooltip-format-disconnected = "Disconnected";
      on-click = "nm-connection-editor";
    };

    pulseaudio = {
      format = "{icon} {volume}%";
      format-bluetooth = "󰂯 {volume}%";
      format-bluetooth-muted = "󰂲 󰝟";
      format-muted = "󰝟";
      format-source = "󰍬 {volume}%";
      format-source-muted = "󰍭";
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
      format = "{icon} {capacity}%";
      format-charging = "󰂄 {capacity}%";
      format-plugged = "󰚥 {capacity}%";
      format-full = "󰁹 {capacity}%";
      format-icons = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
      tooltip-format = "{time}";
    };

    "custom/notification" = {
      tooltip = false;
      format = "{icon} {}";
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
  };

in
with lib;
{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    
    settings = [
      ((if useVerticalBar then verticalConfig else horizontalConfig) // commonModules)
    ];
    
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font Mono";
        font-size: 13px;
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
        padding: 4px 8px;
        border-radius: 16px;
        font-size: 40px;
      }

      #workspaces button {
        color: ${stylix.base04};
        padding: 4px 8px;
        margin: 0 2px;
        border-radius: 12px;
        background: transparent;
        transition: ${betterTransition};
        font-size: 30px;
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
        padding: 8px 16px;
        margin: 4px 4px;
        border-radius: 16px;
        font-weight: bold;
      }

      #clock {
        background: ${stylix.base01};
        color: ${stylix.base05};
        padding: 8px 16px;
        margin: 4px;
        border-radius: 16px;
        font-weight: bold;
      }

      #network {
        background: ${stylix.base01};
        color: ${stylix.base0C};
        padding: 8px 12px;
        margin: 4px 2px;
        border-radius: 16px;
        font-size: 22px;
      }

      #pulseaudio {
        background: ${stylix.base01};
        color: ${stylix.base0A};
        padding: 8px 12px;
        margin: 4px 2px;
        border-radius: 26px;
      }

      #battery {
        background: ${stylix.base01};
        color: ${stylix.base0B};
        padding: 8px 12px;
        margin: 4px 2px;
        border-radius: 22px;
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
        border-radius: 26px;
      }

      #tray {
        background: ${stylix.base01};
        padding: 8px 12px;
        margin: 4px 8px 4px 2px;
        border-radius: 16px;
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

      /* Configuration verticale alternative */
      ${if useVerticalBar then ''
        window#waybar {
          background: transparent;
        }

        #workspaces {
          background: ${stylix.base01};
          border-top-left-radius: 15px;
          border-top-right-radius: 15px;
          padding: 16px 8px 8px;
          font-size: 24px;
          margin: 0;
        }

        #workspaces button {
          padding: 8px 4px;
          margin: 4px 0;
          font-size: 24px;
        }

        #network,
        #pulseaudio,
        #battery,
        #custom-notification,
        #custom-calendar-icon,
        #clock,
        #clock\#date,
        #custom-time-icon,
        #clock\#time {
          background: ${stylix.base00};
          padding: 12px 8px;
          margin: 0;
          border-radius: 0;
          font-size: 16px;
        }

        #custom-separator {
          background: transparent;
          padding: 4px;
          margin: 0;
          color: ${stylix.base03};
        }

        #clock\#time {
          border-bottom-left-radius: 15px;
          border-bottom-right-radius: 15px;
          padding-bottom: 16px;
        }
      '' else ""}
    '';
  };
}
