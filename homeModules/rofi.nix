{ config, pkgs, lib, ... }:
let
  stylix = config.lib.stylix.colors.withHashtag;
in
{
  programs.rofi = {
    enable = true;
    cycle = true;
    location = "center";
    terminal = "${pkgs.kitty}/bin/kitty";
    plugins = with pkgs; [ rofi-calc ];
    theme = "/home/${config.user}/.config/rofi/theme.rasi";
    extraConfig = {
      show-icons = true;
      kb-cancel = "Escape,Super+space";
      modi = "drun,run,filebrowser,window";
      sort = true;
    };
  };

  home.file.".config/rofi/theme.rasi".text = ''
element-icon { size: 1.65ch ; }

configuration {
    display-drun:               "APPS";
    display-run:                "RUN";
    display-filebrowser:        "FILES";
    display-window:             "WINDOW";
    drun-display-format:        "{name}";
    window-format:              "{w} · {c} · {t}";
}

* {
    font:                        "JetBrains Mono Nerd Font 10";
    background:                  ${stylix.base00};
    background-alt:              ${stylix.base01};
    foreground:                  ${stylix.base02};
    selected:                    ${stylix.base05};
    active:                      ${stylix.base04};
    urgent:                      ${stylix.base09};
}

window {
    /* properties for window widget */
    transparency:                "real";
    location:                    center;
    anchor:                      center;
    fullscreen:                  false;
    width:                       1000px;
    x-offset:                    0px;
    y-offset:                    0px;

    /* properties for all widgets */
    enabled:                     true;
    border-radius:               15px;
    cursor:                      "default";
    background-color:            @background;
}

mainbox {
    enabled:                     true;
    spacing:                     0px;
    background-color:            transparent;
    orientation:                 horizontal;
    children:                    [ "imagebox", "listbox" ];
}

imagebox {
    padding:                     20px;
    background-color:            transparent;
    background-image:            url("~/.config/rofi/rofi.png", height);
    orientation:                 vertical;
    children:                    [ "inputbar", "dummy", "mode-switcher" ];
}

listbox {
    spacing:                     20px;
    padding:                     20px;
    background-color:            transparent;
    orientation:                 vertical;
    children:                    [ "message", "listview" ];
}

dummy {
    background-color:            transparent;
}

inputbar {
    enabled:                     true;
    spacing:                     10px;
    padding:                     15px;
    border-radius:               10px;
    background-color:            @background-alt;
    text-color:                  @foreground;
    children:                    [ "textbox-prompt-colon", "entry" ];
}
textbox-prompt-colon {
    enabled:                     true;
    expand:                      false;
    str:                         "";
    background-color:            inherit;
    text-color:                  inherit;
}
entry {
    enabled:                     true;
    background-color:            inherit;
    text-color:                  inherit;
    cursor:                      text;
    placeholder:                 "Search";
    placeholder-color:           inherit;
}

mode-switcher{
    enabled:                     true;
    spacing:                     20px;
    background-color:            transparent;
    text-color:                  @foreground;
}
button {
    padding:                     15px;
    border-radius:               10px;
    background-color:            @background-alt;
    text-color:                  inherit;
    cursor:                      pointer;
}
button selected {
    background-color:            @selected;
    text-color:                  @foreground;
}

listview {
    enabled:                     true;
    columns:                     1;
    lines:                       8;
    cycle:                       true;
    dynamic:                     true;
    scrollbar:                   false;
    layout:                      vertical;
    reverse:                     false;
    fixed-height:                true;
    fixed-columns:               true;
    
    spacing:                     10px;
    background-color:            transparent;
    text-color:                  @foreground;
    cursor:                      "default";
}

element {
    enabled:                     true;
    spacing:                     15px;
    padding:                     8px;
    border-radius:               10px;
    background-color:            transparent;
    text-color:                  @foreground;
    cursor:                      pointer;
}
element normal.normal {
    background-color:            inherit;
    text-color:                  inherit;
}
element normal.urgent {
    background-color:            @urgent;
    text-color:                  @foreground;
}
element normal.active {
    background-color:            @active;
    text-color:                  @foreground;
}
element selected.normal {
    background-color:            @selected;
    text-color:                  @foreground;
}
element selected.urgent {
    background-color:            @urgent;
    text-color:                  @foreground;
}
element selected.active {
    background-color:            @urgent;
    text-color:                  @foreground;
}
element-icon {
    background-color:            transparent;
    text-color:                  inherit;
    size:                        32px;
    cursor:                      inherit;
}
element-text {
    background-color:            transparent;
    text-color:                  inherit;
    cursor:                      inherit;
    vertical-align:              0.5;
    horizontal-align:            0.0;
}

message {
    background-color:            transparent;
}
textbox {
    padding:                     15px;
    border-radius:               10px;
    background-color:            @background-alt;
    text-color:                  @foreground;
    vertical-align:              0.5;
    horizontal-align:            0.0;
}
error-message {
    padding:                     15px;
    border-radius:               20px;
    background-color:            @background;
    text-color:                  @foreground;
}
    '';
}