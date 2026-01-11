{ config, lib, pkgs, ... }:

with lib;

{
  services.tlp = {
    enable = config.isLaptop;
    settings = let
      isAMD = config.cpuVendor == "AMD";
      isIntel = config.cpuVendor == "Intel";
    in {
      TLP_DEFAULT_MODE = "BAT";
      TLP_PERSISTENT_DEFAULT = 1;
      
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 50;
      
      PLATFORM_PROFILE_ON_AC = mkIf isAMD "performance";
      PLATFORM_PROFILE_ON_BAT = mkIf isAMD "low-power";
      
      RUNTIME_PM_ON_AC = "auto";
      RUNTIME_PM_ON_BAT = "auto";
      PCIE_ASPM_ON_AC = "default";
      PCIE_ASPM_ON_BAT = "powersupersave";
      
      USB_AUTOSUSPEND = 1;
      USB_EXCLUDE_AUDIO = 1;
      USB_EXCLUDE_BTUSB = 1;
      
      DISK_IOSCHED = "bfq";
      DISK_IDLE_SECS_ON_AC = 0;
      DISK_IDLE_SECS_ON_BAT = 2;
      DISK_APM_LEVEL_ON_AC = "254 254";
      DISK_APM_LEVEL_ON_BAT = "128 128";
      DISK_SPINDOWN_TIMEOUT_ON_AC = "0 0";
      DISK_SPINDOWN_TIMEOUT_ON_BAT = "1 1";
      
      RADEON_DPM_PERF_LEVEL_ON_AC = mkIf isAMD "auto";
      RADEON_DPM_PERF_LEVEL_ON_BAT = mkIf isAMD "low";
      RADEON_POWER_PROFILE_ON_AC = mkIf isAMD "high";
      RADEON_POWER_PROFILE_ON_BAT = mkIf isAMD "low";
      
      INTEL_GPU_MIN_FREQ_ON_AC = mkIf isIntel "100";
      INTEL_GPU_MIN_FREQ_ON_BAT = mkIf isIntel "100";
      INTEL_GPU_MAX_FREQ_ON_AC = mkIf isIntel "1300";
      INTEL_GPU_MAX_FREQ_ON_BAT = mkIf isIntel "800";
      INTEL_GPU_BOOST_FREQ_ON_AC = mkIf isIntel "1300";
      INTEL_GPU_BOOST_FREQ_ON_BAT = mkIf isIntel "800";
    };
  };

  services.thermald.enable = config.cpuVendor == "Intel";
  services.power-profiles-daemon.enable = mkForce false;
  
  powerManagement = {
    enable = true;
    powertop.enable = true;
    cpuFreqGovernor = mkIf (!config.isLaptop) "performance";
  };
  
  # Wifi
  powerManagement.powerUpCommands = lib.mkIf config.isFrameworkDevice ''
    ${pkgs.iw}/bin/iw dev wlan0 set power_save off || true
  '';

  boot.extraModprobeConfig = lib.mkIf config.isFrameworkDevice ''
    # MediaTek MT7921 (Framework 13 AMD)
    options mt7921e disable_aspm=1
    options mt7921e enable_msi=1
  '';
   
  # Disable suspend-then-hibernate
  systemd.services."systemd-suspend-then-hibernate".enable = mkIf config.isLaptop false;
  systemd.targets."suspend-then-hibernate".enable = mkIf config.isLaptop false;
  
  # Sleep configuration
  systemd.sleep.extraConfig = mkIf config.isLaptop ''
    AllowSuspend=yes
    AllowHibernation=yes
    AllowSuspendThenHibernate=no
    AllowHybridSleep=no
  '';
  
  # Logind configuration
  services.logind.settings.Login = mkIf config.isLaptop {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "lock";
    lidSwitchDocked = "ignore";
    IdleAction = "lock";
    IdleActionSec = 600;
    HandlePowerKey = "suspend";
    HandlePowerKeyLongPress = "poweroff";
    InhibitDelayMaxSec = 5;
  };

  environment.systemPackages = with pkgs; mkIf config.isLaptop [
    powertop
    acpi
    tlp
    lm_sensors
    s-tui
    nvtopPackages.full
  ];
  
  services.system76-scheduler.settings.cfsProfiles.enable = true;
}
