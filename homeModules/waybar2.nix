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
    if isHyprland then
      "hyprland/workspaces"
    else if isSway then
      "sway/workspaces"
    else if isNiri then
      "niri/workspaces"
    else
      null;
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
        spacing = 6;
        margin-top = 7;
        margin-left = 6;
        margin-right = 6;

        modules-left = mkIf (workspacesModule != null) [ workspacesModule ];
        modules-center = [ "clock" ];
        modules-right = [
          "pulseaudio"
          "cpu"
          "memory"
        ]
        ++ optional config.isLaptop "battery"
        ++ [
          "custom/notification"
          "tray"
        ];

        "hyprland/workspaces" = mkIf isHyprland {
          format = "{icon}";
          persistent-workspaces = {
            "*" = 5;
          };
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
        };

        "sway/workspaces" = mkIf isSway {
          format = "{icon}";
          persistent-workspaces = {
            "*" = 5;
          };
        };

        "niri/workspaces" = mkIf isNiri {
          format = "{icon}";
          persistent-workspaces = {
            "*" = 5;
          };
        };

        clock = {
          interval = 1;
          timezone = "Europe/Paris";
          locale = "fr_FR.UTF-8";
          format = "{:%H:%M}";
          format-alt = "{:L%A, %d %B %Y}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 2;
            format = {
              months = "<span color='${stylix.base09}'><b>{}</b></span>";
              days = "<span color='${stylix.base05}'><b>{}</b></span>";
              weeks = "<span color='${stylix.base0F}'><b>{}</b></span>";
              weekdays = "<span color='${stylix.base0A}'><b>{}</b></span>";
              today = "<span color='${stylix.base08}'><b><u>{}</u></b></span>";
            };
          };
          on-click-right = "mode";
          on-scroll-up = "shift_up";
          on-scroll-down = "shift_down";
        };

        cpu = {
          interval = 2;
          format = " {usage}%";
          tooltip = true;
        };

        memory = {
          interval = 5;
          format = " {percentage}%";
          tooltip-format = "RAM: {used:0.1f}G / {total:0.1f}G";
        };

        battery = mkIf config.isLaptop {
          interval = 5;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󱘖 {capacity}%";
          format-icons = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-bluetooth = "{volume}% {icon}";
          format-bluetooth-muted = " {icon}";
          format-muted = "";
          format-source = " {volume}%";
          format-source-muted = "";
          format-icons = {
            headphone = "󱡏";
            hands-free = "󱠳";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
          on-click-right = "pavucontrol";
          on-click = "pavucontrol";
        };

        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
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
        background: transparent;
        min-height: 0;
      }

      window#waybar {
        background: transparent;
      }

      .modules-left,
      .modules-center,
      .modules-right {
        background: ${stylix.base01};
        border-radius: 20px;
        padding: 0 8px;
        margin: 0 4px;
        border: 2px solid ${stylix.base03};
      }

      .modules-left > * { margin: 0 6px; }
      .modules-center > * { margin: 0 6px; }
      .modules-right > * { margin: 0 6px; }

      #workspaces button {
        color: ${stylix.base04};
        background: transparent;
        padding: 5px 10px;
        margin: 0 4px;
        border-radius: 20px;
        transition: all 0.3s cubic-bezier(0.55, 0.0, 0.28, 1.682);
      }

      #workspaces button:hover {
        background: ${stylix.base02};
        color: ${stylix.base05};
      }

      #workspaces button.active,
      #workspaces button.focused {
        background: ${stylix.base03};
        color: ${stylix.base05};
      }

      #workspaces button.urgent {
        background: ${stylix.base08};
        color: ${stylix.base05};
      }

      #clock {
        color: ${stylix.base05};
        padding: 0 12px;
        font-weight: bold;
      }

      #cpu {
        color: ${stylix.base05};
        padding: 0 10px;
      }

      #memory {
        color: ${stylix.base05};
        padding: 0 10px
      }

      #battery {
        color: ${stylix.base05};
        padding: 0 10px;
      }

      #battery.charging {
        color: ${stylix.base05};
      }

      #battery.warning:not(.charging) {
        color: ${stylix.base04};
      }

      #battery.critical:not(.charging) {
        color: ${stylix.base03};
        background: ${stylix.base08};
        animation: blink 1s linear infinite;
      }

      @keyframes blink {
        50% { opacity: 0.5; }
      }

      #pulseaudio {
        color: ${stylix.base05};
        padding: 0 10px;
      }

      #pulseaudio.muted {
        color: ${stylix.base08};
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
      #pulseaudio:hover,
      #clock:hover,
      #custom-notification:hover {
        background: ${stylix.base02};
        border-radius: 20px;
        transition: all 0.3s ease;
      }

      menu,
      tooltip {
        background: ${stylix.base00};
        border: 2px solid ${stylix.base03};
        border-radius: 8px;
        opacity: 1;
        padding: 8px;
      }

      tooltip label {
        color: ${stylix.base05};
      }
    '';
  };
}
