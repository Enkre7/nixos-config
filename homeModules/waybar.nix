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
        modules-center = [ "hyprland/workspaces" ];
        modules-left = [
          "custom/startmenu"
          "cpu"
          "temperature"
          "memory"
          "disk"
          #"hyprland/window"
        ];
        modules-right = [
          #"idle_inhibitor"
          #"network
          "battery"
          "pulseaudio"
          "custom/notification"
          "tray"
          "clock"
        ];

        "hyprland/workspaces" = {
          format = "{name}";
          format-icons = {
            default = " ";
            active = " ";
            urgent = " ";
          };
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
        };
        "clock" = {
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
        "hyprland/window" = {
          max-length = 32;
          icon = true;
          icon-size = 18;
          separate-outputs = false;
          rewrite = {
            "" = " Rien ";
          };
        };
        "cpu" = {
          interval = 5;
          format = " {usage}%";
          on-click = "kitty --class='system-monitor' --hold -e btop";
        };
        "temperature" = {
          format = "{temperatureC}°C";
          interval = 2;
        };
        "memory" = {
          interval = 5;
          format = " {percentage}%";
          on-click = "kitty --class='system-monitor' --hold -e btop";
        };
        "disk" = {
          format = " {percentage_used}%";
          tooltip-format = "{used} / {total}";
          unit = "GB";
          on-click = "kitty --class='disk-monitor' --hold -e bash -c \"duf --sort size && echo -e '\\n---\\n' && lsblk -o NAME,SIZE,FSTYPE,FSUSE%,MOUNTPOINT && echo -e '\\n---\\n' && dust -n 10 /\"";
        };
        "network" = {
          interval = 2;
          format-icons = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          format-ethernet = " Ethernet";
          format-wifi = "{icon} {frequency}Ghz";
          format-disconnected = "󰤮";
          tooltip-format = "{ifname}";
          tooltip-format-wifi = "SSID: {essid}\rSignal: {signaldBm} ({signalStrength}%)\r\r {bandwidthDownOctets} /  {bandwidthDownOctets}\r\rIP: {ipaddr}\rGtw: {gwaddr}/{cidr}";
          tooltip-format-ethernet = " {bandwidthDownOctets} /  {bandwidthDownOctets}\r\rIP: {ipaddr}\rGtw: {gwaddr}/{cidr}";
          tooltip-format-disconnected = "Deconnecté";
        };
        "custom/notification" = {
          tooltip = false;
          format = "{icon} {}";
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
          on-click = "swaync-client -t";
          escape = true;
        };
        "tray" = {
          icon-size = 21;
          spacing = 12;
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
        "custom/startmenu" = {
          tooltip = false;
          format = "";
          on-click = "wlogout";
          on-click-right = "wofi";
        };
        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
          tooltip-format-activated = "Actif";
          tooltip-format-deactivated = "Désactivé";
        };
        "battery" = {
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
      }
    ];
    style = concatStrings [
      ''
        * {
          font-size: 0.8rem;
          border-radius: 0px;
          border: none;
          font-family: JetBrainsMono Nerd Font Mono;
          min-height: 0px;
        }
        window#waybar {
          background-color: transparent;
        }
        #workspaces {
          color: ${stylix.base00};
          background: ${stylix.base01};
          margin: 4px 4px;
          padding: 8px 5px;
          border-radius: 16px;
        }
        #workspaces button {
          font-weight: bold;
          padding: 0px 5px;
          margin: 0px 3px;
          border-radius: 16px;
          color: ${stylix.base00};
          background: ${stylix.base0D};
          background-size: 300% 300%;
          opacity: 0.5;
          transition: ${betterTransition};
        }
        #workspaces button.active {
          font-weight: bold;
          padding: 0px 5px;
          margin: 0px 3px;
          border-radius: 16px;
          color: ${stylix.base00};
          background: ${stylix.base05};
          background-size: 300% 300%;
          transition: ${betterTransition};
          opacity: 1.0;
          min-width: 40px;
        }
        #workspaces button:hover {
          font-weight: bold;
          padding: 0px 5px;
          margin: 0px 3px;
          border-radius: 16px;
          color: ${stylix.base00};
          background: ${stylix.base0D};
          background-size: 300% 300%;
          opacity: 0.8;
          transition: ${betterTransition};
        }
        #workspaces button.active:hover {
          background: ${stylix.base05};
        }
        @keyframes gradient_horizontal {
          0% {
            background-position: 0% 50%;
          }
          50% {
            background-position: 100% 50%;
          }
          100% {
            background-position: 0% 50%;
          }
        }
        @keyframes swiping {
          0% {
            background-position: 0% 200%;
          }
          100% {
            background-position: 200% 200%;
          }
        }
        tooltip {
          background: ${stylix.base00};
          border: 1px solid ${stylix.base0D};
          border-radius: 12px;
        }
        tooltip label {
          color: ${stylix.base07};
        }
        #window, #cpu, #temperature,  #memory, #disk {
          font-weight: bold;
          margin: 4px 0px;
          margin-left: 7px;
          padding: 0px 18px;
          color: ${stylix.base05};
          background: ${stylix.base01};
          border-radius: 24px 10px 24px 10px;
        }
        #custom-startmenu {
          color: ${stylix.base0D};
          background: ${stylix.base01};
          font-size: 33px;
          margin: 0px;
          padding: 0px 25px 0px 15px;
          border-radius: 0px 0px 40px 0px;
        }
        #network, #battery, #pulseaudio, #tray, #custom-notification, #idle_inhibitor {
          font-weight: bold;
          background: ${stylix.base01};
          color: ${stylix.base05};
          margin: 4px 0px;
          margin-right: 7px;
          border-radius: 10px 24px 10px 24px;
          padding: 0px 18px;
        }
        #clock {
          font-weight: bold;
          color: ${stylix.base00};
          background: ${stylix.base05};
          background-size: 300% 300%;
          margin: 0px;
          padding: 0px 15px 0px 30px;
          border-radius: 0px 0px 0px 40px;
        }
      ''
    ];
  };
}
