{ ... }:

{
  # Battery
  services.system76-scheduler.settings.cfsProfiles.enable = true; # Scheduling for CPU cycles  
  services.tlp = {
    enable = true;
    settings = {
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    };
  };
  services.power-profiles-daemon.enable = false;
  powerManagement.powertop.enable = true;
  
  # Computer power comportment
  services.logind = {
    powerKey = "suspend";
    powerKeyLongPress = "poweroff";
    lidSwitch = "suspend-then-hibernate";
    extraConfig = ''
      IdleAction=lock
      HandlePowerKey=suspend
    '';
  };
}