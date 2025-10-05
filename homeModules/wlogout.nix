{ config, pkgs, ... }:

let
  stylix = config.lib.stylix.colors.withHashtag;

  isHyprland = config.wayland.windowManager.hyprland.enable or false;
  isSway = config.wayland.windowManager.sway.enable or false;
  isNiri = builtins.pathExists "${config.xdg.configHome}/niri/config.kdl";

  logoutCommand = 
    if isHyprland then "hyprctl dispatch exit 0"
    else if isSway then "swaymsg exit"
    else if isNiri then "niri msg action quit"
    else "loginctl terminate-user $USER";

  wlogoutWrapper = pkgs.writeShellScriptBin "wlogout-wrapper" ''
    if pgrep -x wlogout >/dev/null 2>&1; then
      pkill -x wlogout
      exit 0
    fi
    
    WLOGOUT_PID=$
    ${pkgs.wlogout}/bin/wlogout "$@" &
    WLOGOUT_REAL_PID=$!
    
    sleep 0.5
    
    ${pkgs.xdotool}/bin/xdotool search --pid $WLOGOUT_REAL_PID --sync 2>/dev/null || true
    
    while kill -0 $WLOGOUT_REAL_PID 2>/dev/null; do
      WINDOW_ID=$(${pkgs.xdotool}/bin/xdotool search --pid $WLOGOUT_REAL_PID 2>/dev/null | head -1)
      if [ -n "$WINDOW_ID" ]; then
        eval $(${pkgs.xdotool}/bin/xdotool getmouselocation --shell 2>/dev/null)
        ${pkgs.xdotool}/bin/xdotool windowfocus --sync $WINDOW_ID 2>/dev/null || true
        ${pkgs.xdotool}/bin/xdotool mousemove --window $WINDOW_ID $X $Y 2>/dev/null || true
      fi
      sleep 0.05
    done
  '';
in
{
  home.packages = [ wlogoutWrapper ];

  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "hyprlock";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "logout";
        action = logoutCommand;
        text = "Logout";
        keybind = "e";
      }
      {
        label = "suspend";
        action = "hyprlock && systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "hibernate";
        action = "systemctl hibernate";
        text = "Hibernate";
        keybind = "h";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
    ];
    style = ''
* {
    font-family: monospace;
    font-size: 14px;
}

window {
    background-color: rgba(24, 27, 32, 0.75);
    color: ${stylix.base03};
}

button {
    background-repeat: no-repeat;
    background-position: center;
    background-size: 20%;
    background-color: transparent;
    animation: gradient_f 20s ease-in infinite;
    transition: all 0.3s ease-in;
    box-shadow: 0 0 10px 2px transparent;
    border: none;
    border-radius: 25px;
    margin: 10px;
}

button:hover,
button:focus {
    background-size: 50%;
    box-shadow: 0 0 10px 3px rgba(0,0,0,.4);
    background-color: ${stylix.base00};
    color: transparent;
    outline: none;
    border: none;
    transition: all 0.3s cubic-bezier(0.55, 0.0, 0.28, 1.682), box-shadow 0.5s ease-in;
}

button:hover:focus {
    outline: none;
    border: none;
}

#lock {
    background-image: image(url("${config.dotfilesPath}/wlogout/icons/lock.png"));
}
#lock:hover, #lock:focus {
    background-image: image(url("${config.dotfilesPath}/wlogout/icons/lock-hover.png"));
}

#logout {
    background-image: image(url("${config.dotfilesPath}/wlogout/icons/logout.png"));
}
#logout:hover, #logout:focus {
    background-image: image(url("${config.dotfilesPath}/wlogout/icons/logout-hover.png"));
}

#suspend {
    background-image: image(url("${config.dotfilesPath}/wlogout/icons/sleep.png"));
}
#suspend:hover, #suspend:focus {
    background-image: image(url("${config.dotfilesPath}/wlogout/icons/sleep-hover.png"));
}

#shutdown {
    background-image: image(url("${config.dotfilesPath}/wlogout/icons/power.png"));
}
#shutdown:hover, #shutdown:focus {
    background-image: image(url("${config.dotfilesPath}/wlogout/icons/power-hover.png"));
}

#reboot {
    background-image: image(url("${config.dotfilesPath}/wlogout/icons/restart.png"));
}
#reboot:hover, #reboot:focus {
    background-image: image(url("${config.dotfilesPath}/wlogout/icons/restart-hover.png"));
}
#hibernate {
    background-image: image(url("${config.dotfilesPath}/wlogout/icons/hibernate.png"));
}
#hibernate:hover, #hibernate:focus {
    background-image: image(url("${config.dotfilesPath}/wlogout/icons/hibernate-hover.png"));
}
    '';
  };
}
