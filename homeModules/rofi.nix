{ config, pkgs, lib, ... }:

let
  stylix = config.lib.stylix.colors;
  
  isHyprland = config.wayland.windowManager.hyprland.enable or false;
  isSway = config.wayland.windowManager.sway.enable or false;
  isNiri = builtins.pathExists "${config.xdg.configHome}/niri/config.kdl";

  logoutCommand = 
    if isHyprland then "hyprctl dispatch exit 0"
    else if isSway then "swaymsg exit"
    else if isNiri then "niri msg action quit"
    else "loginctl terminate-user $USER";

  powermenuScript = pkgs.writeShellScriptBin "rofi-powermenu" ''
    #!/usr/bin/env bash

    shutdown='⏻'
    reboot='󰜉'
    lock='󰍁'
    suspend='⏾'
    logout='󰗽'

    rofi_cmd() {
        ${pkgs.rofi}/bin/rofi -dmenu \
            -p "Power Menu" \
            -theme ${config.xdg.configHome}/rofi/powermenu.rasi
    }

    run_rofi() {
        echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
    }

    run_cmd() {
        case $1 in
            "$shutdown")
                systemctl poweroff
                ;;
            "$reboot")
                systemctl reboot
                ;;
            "$lock")
                hyprlock
                ;;
            "$suspend")
                hyprlock && systemctl suspend
                ;;
            "$logout")
                ${logoutCommand}
                ;;
        esac
    }

    chosen="$(run_rofi)"
    if [[ -n "$chosen" ]]; then
        run_cmd "$chosen"
    fi
  '';

in
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    terminal = "${pkgs.kitty}/bin/kitty";
    
    extraConfig = {
      modi = "drun,run,filebrowser,window";
      show-icons = true;
      terminal = "kitty";
      drun-display-format = "{icon} {name}";
      location = 0;
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "   Apps ";
      display-run = "   Run ";
      display-filebrowser = "   File ";
      display-window = " 﩯  Window";
      sidebar-mode = true;
    };
    
    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        bg-col = mkLiteral "#${stylix.base00}";
        bg-col-light = mkLiteral "#${stylix.base01}";
        border-col = mkLiteral "#${stylix.base0D}";
        selected-col = mkLiteral "#${stylix.base0D}";
        blue = mkLiteral "#${stylix.base0D}";
        fg-col = mkLiteral "#${stylix.base05}";
        fg-col2 = mkLiteral "#${stylix.base08}";
        grey = mkLiteral "#${stylix.base03}";
        width = 600;
        font = "${config.stylix.fonts.monospace.name} 14";
      };

      "element-text, element-icon, mode-switcher" = {
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };

      window = {
        height = mkLiteral "360px";
        border = mkLiteral "3px";
        border-color = mkLiteral "@border-col";
        background-color = mkLiteral "@bg-col";
        border-radius = mkLiteral "20px";
      };

      mainbox = {
        background-color = mkLiteral "@bg-col";
      };

      inputbar = {
        children = mkLiteral "[prompt,entry]";
        background-color = mkLiteral "@bg-col-light";
        border-radius = mkLiteral "15px";
        padding = mkLiteral "8px 12px";
        margin = mkLiteral "12px";
      };

      prompt = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@blue";
        padding = mkLiteral "6px 10px 6px 10px";
        font = "${config.stylix.fonts.monospace.name} Bold 16";
      };

      entry = {
        padding = mkLiteral "6px";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg-col";
        placeholder = "Search...";
        placeholder-color = mkLiteral "@grey";
      };

      listview = {
        border = mkLiteral "0px 0px 0px";
        padding = mkLiteral "6px 0px 0px";
        margin = mkLiteral "10px 12px 10px 12px";
        columns = 2;
        lines = 5;
        background-color = mkLiteral "@bg-col";
        spacing = mkLiteral "4px";
      };

      element = {
        padding = mkLiteral "8px 10px";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg-col";
        border-radius = mkLiteral "12px";
      };

      "element-icon" = {
        size = mkLiteral "28px";
        margin = mkLiteral "0 8px 0 0";
      };

      "element selected" = {
        background-color = mkLiteral "@selected-col";
        text-color = mkLiteral "@bg-col";
      };

      mode-switcher = {
        spacing = 0;
        margin = mkLiteral "10px 12px 12px 12px";
      };

      button = {
        padding = mkLiteral "10px";
        background-color = mkLiteral "@bg-col-light";
        text-color = mkLiteral "@grey";
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.5";
        border-radius = mkLiteral "12px";
        margin = mkLiteral "0 4px";
      };

      "button selected" = {
        background-color = mkLiteral "@bg-col";
        text-color = mkLiteral "@blue";
      };

      message = {
        background-color = mkLiteral "@bg-col-light";
        margin = mkLiteral "12px";
        padding = mkLiteral "8px";
        border-radius = mkLiteral "12px";
      };

      textbox = {
        padding = mkLiteral "6px";
        margin = mkLiteral "20px 0px 0px 20px";
        text-color = mkLiteral "@blue";
        background-color = mkLiteral "transparent";
      };
    };
  };

  xdg.configFile."rofi/powermenu.rasi".text = ''
    configuration {
        show-icons:                 false;
    }

    * {
        background:     #${stylix.base00};
        background-alt: #${stylix.base01};
        foreground:     #${stylix.base0D};
        selected:       #${stylix.base02};
        active:         #${stylix.base01};
        urgent:         #${stylix.base08};
        font:           "${config.stylix.fonts.monospace.name} 10";
    }

    window {
        transparency:                "real";
        location:                    west;
        anchor:                      west;
        fullscreen:                  false;
        width:                       115px;
        x-offset:                    15px;
        y-offset:                    0px;

        enabled:                     true;
        margin:                      0px;
        padding:                     0px;
        border:                      3px solid;
        border-radius:               12px;
        border-color:                #${stylix.base0D};
        cursor:                      "default";
        background-color:            @background;
    }

    mainbox {
        enabled:                     true;
        spacing:                     15px;
        margin:                      0px;
        padding:                     15px;
        border:                      0px solid;
        border-radius:               0px;
        border-color:                @selected;
        background-color:            transparent;
        children:                    [ "listview" ];
    }

    listview {
        enabled:                     true;
        columns:                     1;
        lines:                       5;
        cycle:                       true;
        dynamic:                     true;
        scrollbar:                   false;
        layout:                      vertical;
        reverse:                     false;
        fixed-height:                true;
        fixed-columns:               true;
        
        spacing:                     15px;
        margin:                      0px;
        padding:                     0px;
        border:                      0px solid;
        border-radius:               0px;
        border-color:                @selected;
        background-color:            transparent;
        text-color:                  @foreground;
        cursor:                      "default";
    }

    element {
        enabled:                     true;
        spacing:                     0px;
        margin:                      0px;
        padding:                     20px 0px;
        border:                      0px solid;
        border-radius:               100%;
        border-color:                @selected;
        background-color:            @background-alt;
        text-color:                  @foreground;
        cursor:                      pointer;
    }
    
    element-text {
        font:                        "${config.stylix.fonts.monospace.name} Bold 20";
        background-color:            transparent;
        text-color:                  inherit;
        cursor:                      inherit;
        vertical-align:              0.5;
        horizontal-align:            0.5;
    }
    
    element selected.normal {
        background-color:            var(selected);
        text-color:                  var(background);
    }
  '';

  home.packages = [
    powermenuScript
    (pkgs.writeShellScriptBin "rofi-launcher" ''
      if pgrep -x rofi >/dev/null 2>&1; then
        pkill -x rofi
        exit 0
      fi
      ${pkgs.rofi}/bin/rofi -show drun
    '')
  ];
}
