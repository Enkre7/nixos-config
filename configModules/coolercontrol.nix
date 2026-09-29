{ config, lib, pkgs, ... }:

let
  stylix = config.lib.stylix.colors;
  customTheme = {
    accent = "${stylix.base0B-rgb-r} ${stylix.base0B-rgb-g} ${stylix.base0B-rgb-b}";
    bgOne = "${stylix.base00-rgb-r} ${stylix.base00-rgb-g} ${stylix.base00-rgb-b}";
    bgTwo = "${stylix.base01-rgb-r} ${stylix.base01-rgb-g} ${stylix.base01-rgb-b}";
    borderOne = "${stylix.base03-rgb-r} ${stylix.base03-rgb-g} ${stylix.base03-rgb-b} 0.25";
    textColor = "${stylix.base05-rgb-r} ${stylix.base05-rgb-g} ${stylix.base05-rgb-b}";
    textColorSecondary = "${stylix.base04-rgb-r} ${stylix.base04-rgb-g} ${stylix.base04-rgb-b}";
  };
in
{
  programs.coolercontrol.enable = true;
  environment.systemPackages = [ pkgs.i2c-tools ] ++ lib.optional (!config.isLaptop) pkgs.liquidctl;

  # Nuvoton NCT6687D motherboard fan controller (MSI)
  boot.extraModulePackages = lib.optional (!config.isLaptop) config.boot.kernelPackages.nct6687d;
  boot.kernelModules = lib.optional (!config.isLaptop) "nct6687";

  systemd.tmpfiles.rules = [
    "d /etc/coolercontrol 0755 root root -"
  ]
  ++ lib.optionals config.isLaptop [
    # Monitoring only: fans are driven by fw-fanctrl
    "C /etc/coolercontrol/config-ui.json 0644 root root - ${pkgs.writeText "config-ui.json" (builtins.toJSON {
      themeMode = "custom theme";
      inherit customTheme;
      chartLineScale = 1.5;
      time24 = true;
      showOnboarding = false;
    })}"
  ]
  ++ lib.optionals (!config.isLaptop) [
    # Main daemon config
    "C /etc/coolercontrol/config.toml 0644 root root - ${pkgs.writeText "config.toml" ''
      [devices]
      e58087daad95f0f3b56c8b50a213331a7d256dd37aff9c0d1d560a27b7fbaeb2 = "NVIDIA GeForce RTX 3080"
      1205d09aeafc8a21acccd3984d470b0077af137ccef4670d27f872edc872c094 = "AMD Ryzen 9 3900X 12-Core Processor"
      8ed002dbd21ab359b02a7e48d0f9ba2db1809d6f5698aeb3b30283d1cbfd841f = "NZXT Kraken Z (Z53, Z63 or Z73)"
      bf1ee4390dedadd8a3f52c284a497e8bd94dc8e3b82dcb8c201abc60ca996ee9 = "nvme"
      19e098e312e1b1b39163a343ea22b6ea17f18ec1a803ffe0ce44f5bacd6076ee = "Custom Sensors"
      257f51093553e2b66f029c53e7335a60a6d593228d2020ca47d4931b60dd976f = "enp4s0"

      [legacy690]

      [device-settings]

      [device-settings.8ed002dbd21ab359b02a7e48d0f9ba2db1809d6f5698aeb3b30283d1cbfd841f]
      lcd = { lcd = { mode = "temp", brightness = 50, orientation = 90, colors = [], temp_source = { temp_name = "temp1", device_uid = "1205d09aeafc8a21acccd3984d470b0077af137ccef4670d27f872edc872c094" } } }
      pump = { profile_uid = "26c279a2-dee2-4fca-8eff-a6f51a7cdea0" }
      fan = { profile_uid = "0840dd7f-04cb-4c72-9303-4d78f0e92a55" }
      external = { lighting = { mode = "off", colors = [] } }

      [device-settings.e58087daad95f0f3b56c8b50a213331a7d256dd37aff9c0d1d560a27b7fbaeb2]
      fan1 = { profile_uid = "b7ca4f9a-a1c3-42d9-b16c-a2dd531e4890" }

      [[profiles]]
      uid = "0"
      name = "Default Profile"
      p_type = "Default"
      function = "0"

      [[profiles]]
      uid = "0840dd7f-04cb-4c72-9303-4d78f0e92a55"
      name = "Radiator fans"
      p_type = "Mix"
      member_profile_uids = ["5a1d6c1e-3b0f-4b53-9d2e-7f0c1a2b3c01", "5a1d6c1e-3b0f-4b53-9d2e-7f0c1a2b3c02"]
      mix_function_type = "Max"
      function_uid = "0"

      [[profiles]]
      uid = "5a1d6c1e-3b0f-4b53-9d2e-7f0c1a2b3c01"
      name = "Fans - liquid"
      p_type = "Graph"
      speed_profile = [[25.0, 25], [30.0, 28], [33.0, 35], [36.0, 50], [40.0, 75], [44.0, 100], [50.0, 100]]
      temp_source = { temp_name = "liquid", device_uid = "8ed002dbd21ab359b02a7e48d0f9ba2db1809d6f5698aeb3b30283d1cbfd841f" }
      temp_min = 20.0
      temp_max = 50.0
      function_uid = "02ba5ea0-89cc-4085-808f-c3b1cc97963b"
      offset_profile = []

      [[profiles]]
      uid = "5a1d6c1e-3b0f-4b53-9d2e-7f0c1a2b3c02"
      name = "Fans - CPU safety"
      p_type = "Graph"
      speed_profile = [[20.0, 0], [75.0, 0], [85.0, 60], [92.0, 100], [100.0, 100]]
      temp_source = { temp_name = "temp1", device_uid = "1205d09aeafc8a21acccd3984d470b0077af137ccef4670d27f872edc872c094" }
      temp_min = 20.0
      temp_max = 100.0
      function_uid = "02ba5ea0-89cc-4085-808f-c3b1cc97963b"
      offset_profile = []

      [[profiles]]
      uid = "26c279a2-dee2-4fca-8eff-a6f51a7cdea0"
      name = "Pump"
      p_type = "Graph"
      speed_profile = [[25.0, 50], [32.0, 55], [36.0, 70], [40.0, 90], [44.0, 100], [50.0, 100]]
      temp_source = { temp_name = "liquid", device_uid = "8ed002dbd21ab359b02a7e48d0f9ba2db1809d6f5698aeb3b30283d1cbfd841f" }
      temp_min = 20.0
      temp_max = 50.0
      function_uid = "0b8845ee-d627-4286-93d2-8c47fcc45cdf"
      offset_profile = []

      [[profiles]]
      uid = "b7ca4f9a-a1c3-42d9-b16c-a2dd531e4890"
      name = "GPU"
      p_type = "Graph"
      speed_profile = [[20.0, 0], [52.0, 0], [58.0, 30], [66.0, 45], [74.0, 65], [82.0, 100], [100.0, 100]]
      temp_source = { temp_name = "GPU Temp", device_uid = "e58087daad95f0f3b56c8b50a213331a7d256dd37aff9c0d1d560a27b7fbaeb2" }
      temp_min = 20.0
      temp_max = 100.0
      function_uid = "d80d71a5-43df-4730-82e5-04fcf0186263"
      offset_profile = []

      [[functions]]
      uid = "0"
      name = "Default Function"
      f_type = "Identity"

      [[functions]]
      uid = "02ba5ea0-89cc-4085-808f-c3b1cc97963b"
      name = "Fans - smooth"
      f_type = "Standard"
      deviance = 1.0
      only_downward = true
      response_delay = 3
      duty_minimum = 1
      duty_maximum = 8
      step_size_min_decreasing = 1
      step_size_max_decreasing = 3
      bypass_min_at_extremes = true

      [[functions]]
      uid = "0b8845ee-d627-4286-93d2-8c47fcc45cdf"
      name = "Pump - smooth"
      f_type = "Standard"
      deviance = 1.0
      only_downward = true
      response_delay = 5
      duty_minimum = 1
      duty_maximum = 5
      step_size_min_decreasing = 1
      step_size_max_decreasing = 2

      [[functions]]
      uid = "d80d71a5-43df-4730-82e5-04fcf0186263"
      name = "GPU - zero RPM"
      f_type = "Standard"
      deviance = 4.0
      only_downward = true
      response_delay = 5
      duty_minimum = 1
      duty_maximum = 10
      step_size_min_decreasing = 1
      step_size_max_decreasing = 3
      bypass_min_at_extremes = true

      [settings]
      apply_on_boot = true
      liquidctl_integration = true
      hide_duplicate_devices = true
      no_init = false
      startup_delay = 2
      thinkpad_full_speed = false
      compress = false
      drivetemp_suspend = false
      poll_rate = 1.0
    ''}"
    
    # Temperature alerts
    "C /etc/coolercontrol/alerts.json 0644 root root - ${pkgs.writeText "alerts.json" ''
      {"alerts":[{"uid":"936b6904-90ef-4ac3-a8f2-f5e82ef2930f","name":"CPU to hot","channel_source":{"device_uid":"1205d09aeafc8a21acccd3984d470b0077af137ccef4670d27f872edc872c094","channel_name":"temp1","channel_metric":"Temp"},"min":0.0,"max":85.0,"state":"Inactive","warmup_duration":10.0},{"uid":"673fc641-c8af-423d-af54-9413323620b4","name":"GPU to hot","channel_source":{"device_uid":"e58087daad95f0f3b56c8b50a213331a7d256dd37aff9c0d1d560a27b7fbaeb2","channel_name":"GPU Temp","channel_metric":"Temp"},"min":0.0,"max":90.0,"state":"Inactive","warmup_duration":10.0}],"logs":[]}
    ''}"
    
    # Cooling modes
    "C /etc/coolercontrol/modes.json 0644 root root - ${pkgs.writeText "modes.json" ''
      {"modes":[],"order":[],"current_active_mode":null,"previous_active_mode":null}
    ''}"
    
    # UI config with Stylix theme
    "C /etc/coolercontrol/config-ui.json 0644 root root - ${pkgs.writeText "config-ui.json" (builtins.toJSON {
      devices = [
        "19e098e312e1b1b39163a343ea22b6ea17f18ec1a803ffe0ce44f5bacd6076ee"
        "1205d09aeafc8a21acccd3984d470b0077af137ccef4670d27f872edc872c094"
        "e58087daad95f0f3b56c8b50a213331a7d256dd37aff9c0d1d560a27b7fbaeb2"
        "8ed002dbd21ab359b02a7e48d0f9ba2db1809d6f5698aeb3b30283d1cbfd841f"
        "257f51093553e2b66f029c53e7335a60a6d593228d2020ca47d4931b60dd976f"
        "bf1ee4390dedadd8a3f52c284a497e8bd94dc8e3b82dcb8c201abc60ca996ee9"
      ];
      deviceSettings = [
        { names = []; sensorAndChannelSettings = []; }
        {
          names = ["temp1" "temp3" "temp4" "CPU Load" "power0" "CPU Freq Avg" "CPU Freq Max" "CPU Freq Min"];
          sensorAndChannelSettings = [
            { viewType = "Control"; }
            { viewType = "Control"; }
            { viewType = "Control"; }
            { viewType = "Control"; }
            { viewType = "Control"; }
            { viewType = "Control"; }
            { viewType = "Control"; }
            { viewType = "Control"; }
          ];
        }
        {
          names = ["GPU Temp" "GPU Load" "GPU Power" "freq_graphics" "freq_sm" "freq_memory" "freq_video" "fan1"];
          sensorAndChannelSettings = [
            { viewType = "Control"; }
            { viewType = "Control"; }
            { viewType = "Control"; }
            { viewType = "Control"; }
            { viewType = "Control"; }
            { viewType = "Control"; }
            { viewType = "Control"; }
            {
              viewType = "Control";
              channelDashboard = {
                uid = "e97b707e-d221-4eaa-83bb-5e1aac7b3659";
                name = "fan1";
                chartType = "Time Chart";
                timeRangeSeconds = 300;
                autoScaleDegree = false;
                autoScaleFrequency = true;
                autoScaleWatts = true;
                degreeMax = 100;
                degreeMin = 0;
                frequencyMax = 10000;
                frequencyMin = 0;
                wattsMax = 800;
                wattsMin = 0;
                dataTypes = [];
                deviceChannelNames = [{
                  deviceUID = "e58087daad95f0f3b56c8b50a213331a7d256dd37aff9c0d1d560a27b7fbaeb2";
                  channelName = "fan1";
                }];
              };
            }
          ];
        }
        {
          names = ["liquid" "fan" "pump" "external" "lcd"];
          sensorAndChannelSettings = [
            {
              viewType = "Control";
              channelDashboard = {
                uid = "7bf71e83-5646-4650-adbc-4bfee25f2a90";
                name = "Liquid";
                chartType = "Time Chart";
                timeRangeSeconds = 300;
                autoScaleDegree = false;
                autoScaleFrequency = true;
                autoScaleWatts = true;
                degreeMax = 100;
                degreeMin = 0;
                frequencyMax = 10000;
                frequencyMin = 0;
                wattsMax = 800;
                wattsMin = 0;
                dataTypes = [];
                deviceChannelNames = [{
                  deviceUID = "8ed002dbd21ab359b02a7e48d0f9ba2db1809d6f5698aeb3b30283d1cbfd841f";
                  channelName = "liquid";
                }];
              };
            }
            {
              viewType = "Control";
              channelDashboard = {
                uid = "ce4e4303-2536-4c6f-8727-737f6c447119";
                name = "Fan";
                chartType = "Time Chart";
                timeRangeSeconds = 300;
                autoScaleDegree = false;
                autoScaleFrequency = true;
                autoScaleWatts = true;
                degreeMax = 100;
                degreeMin = 0;
                frequencyMax = 10000;
                frequencyMin = 0;
                wattsMax = 800;
                wattsMin = 0;
                dataTypes = [];
                deviceChannelNames = [{
                  deviceUID = "8ed002dbd21ab359b02a7e48d0f9ba2db1809d6f5698aeb3b30283d1cbfd841f";
                  channelName = "fan";
                }];
              };
            }
            {
              viewType = "Control";
              channelDashboard = {
                uid = "d349d9dd-cfce-4fcf-9617-854d4f5accfb";
                name = "Pump";
                chartType = "Time Chart";
                timeRangeSeconds = 300;
                autoScaleDegree = false;
                autoScaleFrequency = true;
                autoScaleWatts = true;
                degreeMax = 100;
                degreeMin = 0;
                frequencyMax = 10000;
                frequencyMin = 0;
                wattsMax = 800;
                wattsMin = 0;
                dataTypes = [];
                deviceChannelNames = [{
                  deviceUID = "8ed002dbd21ab359b02a7e48d0f9ba2db1809d6f5698aeb3b30283d1cbfd841f";
                  channelName = "pump";
                }];
              };
            }
            { viewType = "Control"; }
            { viewType = "Control"; }
          ];
        }
        {
          names = ["temp1" "temp2"];
          sensorAndChannelSettings = [
            { viewType = "Control"; }
            { viewType = "Control"; }
          ];
        }
        {
          names = ["temp1" "temp2" "temp3"];
          sensorAndChannelSettings = [
            { viewType = "Control"; }
            { viewType = "Control"; }
            { viewType = "Control"; }
          ];
        }
      ];
      dashboards = [{
        uid = "797aa5b4-d32e-412c-8423-e9acb389d45e";
        name = "System";
        chartType = "Time Chart";
        timeRangeSeconds = 60;
        autoScaleDegree = false;
        autoScaleFrequency = true;
        autoScaleWatts = true;
        degreeMax = 100;
        degreeMin = 0;
        frequencyMax = 10000;
        frequencyMin = 0;
        wattsMax = 800;
        wattsMin = 0;
        dataTypes = ["Temp" "Duty" "Load"];
        deviceChannelNames = [];
      }];
      homeDashboard = "797aa5b4-d32e-412c-8423-e9acb389d45e";
      themeMode = "custom theme";
      chartLineScale = 1.5;
      time24 = true;
      menuOrder = [];
      expandedMenuIds = [
        "dashboards" "alerts" "functions" "profiles" "modes"
        "1205d09aeafc8a21acccd3984d470b0077af137ccef4670d27f872edc872c094"
        "e58087daad95f0f3b56c8b50a213331a7d256dd37aff9c0d1d560a27b7fbaeb2"
        "8ed002dbd21ab359b02a7e48d0f9ba2db1809d6f5698aeb3b30283d1cbfd841f"
        "19e098e312e1b1b39163a343ea22b6ea17f18ec1a803ffe0ce44f5bacd6076ee"
        "257f51093553e2b66f029c53e7335a60a6d593228d2020ca47d4931b60dd976f"
        "bf1ee4390dedadd8a3f52c284a497e8bd94dc8e3b82dcb8c201abc60ca996ee9"
      ];
      pinnedIds = [];
      collapsedMainMenu = false;
      hideMenuCollapseIcon = false;
      mainMenuWidthRem = 24;
      frequencyPrecision = 1000;
      inherit customTheme;
      entityColors = [];
      showOnboarding = false;
    })}"
  ]
  ++ [
    "d /root/.config/org.coolercontrol.CoolerControl 0755 root root -"
    "C /root/.config/org.coolercontrol.CoolerControl/CoolerControl.conf 0644 root root - ${pkgs.writeText "CoolerControl.conf" ''
      [General]
      closeToTray=true
      startInTray=true
    ''}"
  ];
}
