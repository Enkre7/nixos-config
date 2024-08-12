{ config, lib, ... }:

let
  stylix = config.lib.stylix.colors.withHashtag;
in
{
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
      action = "hyprctl dispatch exit 0";
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
    border: transparent;
    border-radius: 25px;
    margin: 10px;
}

button:hover {
    background-size: 50%;
    box-shadow: 0 0 10px 3px rgba(0,0,0,.4);
    background-color: ${stylix.base00};
    color: transparent;
    transition: all 0.3s cubic-bezier(0.55, 0.0, 0.28, 1.682), box-shadow 0.5s ease-in;
}

button:focus {
    background-size: 25%;
    box-shadow: none;
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

