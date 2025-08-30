{ config, lib, pkgs, ... }:

with lib;

{
  services.tlp = {
    enable = config.isLaptop;
    settings = let
      isAMD = config.cpuVendor == "AMD";
      isIntel = config.cpuVendor == "Intel";
    in {
      # General settings
      TLP_DEFAULT_MODE = "BAT";
      TLP_PERSISTENT_DEFAULT = 1;
      
      # CPU settings - these are safe for both Intel and AMD
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
      
      # Vendor-specific platform profiles
      PLATFORM_PROFILE_ON_AC = mkIf isAMD "performance";
      PLATFORM_PROFILE_ON_BAT = mkIf isAMD "low-power";
      
      # Power management for PCI devices
      RUNTIME_PM_ON_AC = "auto";
      RUNTIME_PM_ON_BAT = "auto";
      PCIE_ASPM_ON_AC = "default";
      PCIE_ASPM_ON_BAT = "powersupersave";
      
      # USB power management
      USB_AUTOSUSPEND = 1;
      USB_EXCLUDE_AUDIO = 1;
      USB_EXCLUDE_BTUSB = 1;
      
      # Disk settings
      DISK_IOSCHED = "bfq";
      DISK_IDLE_SECS_ON_AC = 0;
      DISK_IDLE_SECS_ON_BAT = 2;
      DISK_APM_LEVEL_ON_AC = "254 254";
      DISK_APM_LEVEL_ON_BAT = "128 128";
      DISK_SPINDOWN_TIMEOUT_ON_AC = "0 0";
      DISK_SPINDOWN_TIMEOUT_ON_BAT = "1 1";
      
      # AMD-specific GPU settings
      RADEON_DPM_PERF_LEVEL_ON_AC = mkIf isAMD "auto";
      RADEON_DPM_PERF_LEVEL_ON_BAT = mkIf isAMD "low";
      RADEON_POWER_PROFILE_ON_AC = mkIf isAMD "high";
      RADEON_POWER_PROFILE_ON_BAT = mkIf isAMD "low";
      
      # Intel-specific GPU settings - only applied on Intel systems
      INTEL_GPU_MIN_FREQ_ON_AC = mkIf isIntel "100";
      INTEL_GPU_MIN_FREQ_ON_BAT = mkIf isIntel "100";
      INTEL_GPU_MAX_FREQ_ON_AC = mkIf isIntel "1300";
      INTEL_GPU_MAX_FREQ_ON_BAT = mkIf isIntel "800";
      INTEL_GPU_BOOST_FREQ_ON_AC = mkIf isIntel "1300";
      INTEL_GPU_BOOST_FREQ_ON_BAT = mkIf isIntel "800";
    };
  };

  # Thermald service (especially useful for Intel CPUs)
  services.thermald.enable = config.cpuVendor == "Intel";
  
  # Power profiles daemon is handled by nixos-hardware, disable to avoid conflicts
  services.power-profiles-daemon.enable = mkForce false;
  
  powerManagement = {
    enable = true;
    powertop.enable = true;
    cpuFreqGovernor = mkIf (!config.isLaptop) "performance";
  };
  
  # Hybrid sleep configuration
  systemd.sleep.extraConfig = mkIf config.isLaptop ''
    [Sleep]
    HibernateDelaySec=120m
    SuspendEstimationSec=15
    HibernateEstimationSec=30
  '';
  
  services.logind = {
    settings.Login = {
      HandleLidSwitch = mkIf config.isLaptop "suspend-then-hibernate";
      HandleLidSwitchExternalPower = mkIf config.isLaptop "lock";
      IdleAction = "lock";
      IdleActionSec = 300;
      HandlePowerKey = "suspend";
      HandlePowerKeyLongPress = "poweroff";
    };
  };

  # Battery management utilities
  environment.systemPackages = with pkgs; mkIf config.isLaptop [
    powertop
    acpi
    tlp
    lm_sensors
    s-tui
    nvtopPackages.full
  ];
  
  # Enable the scheduler profiles, which is especially useful on Ryzen systems
  services.system76-scheduler.settings.cfsProfiles.enable = true;
}
