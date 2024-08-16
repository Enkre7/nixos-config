{ ... }:

{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        ignore_dbus_inhibit = false;             # whether to ignore dbus-sent idle-inhibit requests (used by e.g. firefox or steam)
        lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
        before_sleep_cmd = "loginctl lock-session";    # lock before suspend.
        after_sleep_cmd = "hyprctl dispatch dpms on";  # to avoid having to press a key twice to turn on the display.
      };

      listener = [ 
        # Screenlock
        {
          timeout = 600; # in seconds
          on-timeout = "hyprlock"; # command to run when timeout has passed
        }
        
        # Brightness
        {
          timeout = 540;
          onTimeout = "brightnessctl -s set 0";  # set monitor backlight to minimum, avoid 0 on OLED monitor.
          onResume = "brightnessctl -r";   # monitor backlight restor.
        }

        # Suspend
        {
          timeout = 900; # in seconds
          on-timeout = "systemctl suspend"; # command to run when timeout has passed.
        }
      ];
    };
  };
}
