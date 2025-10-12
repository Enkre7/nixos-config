{ config, pkgs, lib, ... }:

let
  stylix = config.lib.stylix.colors;
in
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
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

      textbox-prompt-colon = {
        expand = false;
        str = ":";
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

  # Script wrapper pour Rofi (similaire à wlogout-wrapper)
  home.packages = [
    (pkgs.writeShellScriptBin "rofi-launcher" ''
      if pgrep -x rofi >/dev/null 2>&1; then
        pkill -x rofi
        exit 0
      fi
      ${pkgs.rofi-wayland}/bin/rofi -show drun
    '')
  ];
}
