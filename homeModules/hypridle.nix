{ ... }:

{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
        before_sleep_cmd = "loginctl lock-session";    # lock before suspend.
        after_sleep_cmd = "hyprctl dispatch dpms on";  # to avoid having to press a key twice to turn on the display.
      };

      listener = [ 
        {
          timeout = 180; # in seconds
          on-timeout = "loginctl lock-session";
        }

        {
          timeout = 240;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }

        {
          timeout = 360;
          onTimeout = "brightnessctl -s set 0";  # set screen light to minimum
          onResume = "brightnessctl -r";   # restore screen light
        }

        {
          timeout = 540;
          on-timeout = "pidof steam || systemctl suspend || loginctl suspend";
        }
      ];
    };
  };
}
