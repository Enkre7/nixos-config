{ config, lib, pkgs, ... }:

let
  stylix = config.lib.stylix.colors;
  hasFingerprint = config.isLaptop;
  
  placeholderText = if hasFingerprint 
    then "Mot de passe ou empreinte"
    else "Mot de passe";
in
{
  home.packages = with pkgs; [
    swaylock-effects
  ];

  # Lock script
  home.file.".local/bin/lock" = {
    text = ''
      #!/usr/bin/env bash
      
      BASE00="${stylix.base00}"
      BASE05="${stylix.base05}"
      BASE0D="${stylix.base0D}"
      BASE08="${stylix.base08}"
      BASE0B="${stylix.base0B}"
      BASE09="${stylix.base09}"
      
      swaylock \
        --image "${config.wallpaper}" \
        --scaling fill \
        \
        --effect-blur 6x2 \
        --effect-vignette 0.7:0.15 \
        \
        --indicator \
        --indicator-radius 100 \
        --indicator-thickness 7 \
        --indicator-caps-lock \
        \
        --ring-color "$BASE00" \
        --key-hl-color "$BASE0D" \
        --bs-hl-color "$BASE08" \
        --ring-ver-color "$BASE0B" \
        --ring-wrong-color "$BASE08" \
        --ring-clear-color "$BASE09" \
        \
        --inside-color "''${BASE00}88" \
        --inside-ver-color "''${BASE0B}88" \
        --inside-wrong-color "''${BASE08}88" \
        --inside-clear-color "''${BASE09}88" \
        \
        --line-color "$BASE0D" \
        --line-ver-color "$BASE0B" \
        --line-wrong-color "$BASE08" \
        --line-clear-color "$BASE09" \
        --separator-color "00000000" \
        \
        --text-color "$BASE05" \
        --text-ver-color "$BASE00" \
        --text-wrong-color "$BASE00" \
        --text-clear-color "$BASE00" \
        --text-caps-lock-color "$BASE09" \
        \
        --clock \
        --timestr "%H:%M" \
        --datestr "%A %d %B %Y" \
        \
        --indicator-idle-visible \
        --indicator-x-position 960 \
        --indicator-y-position 800 \
        \
        --fade-in 0.2 \
        --grace 2 \
        --grace-no-mouse \
        --grace-no-touch \
        \
        --show-failed-attempts \
        --show-keyboard-layout \
        \
        --font "JetBrains Mono Nerd Font" \
        --font-size 24
    '';
    executable = true;
  };
}
