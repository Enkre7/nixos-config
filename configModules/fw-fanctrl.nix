{ ... }:

{
  hardware.fw-fanctrl = {
    enable = true;
    config = {
      defaultStrategy = "quiet-performance";
      strategyOnDischarging = "quiet-battery";
      strategies = {
        quiet-performance = {
          fanSpeedUpdateFrequency = 5;
          movingAverageInterval = 20;
          speedCurve = [
            { temp = 0; speed = 0; }
            { temp = 50; speed = 0; }
            { temp = 58; speed = 15; }
            { temp = 66; speed = 25; }
            { temp = 74; speed = 40; }
            { temp = 82; speed = 65; }
            { temp = 90; speed = 100; }
          ];
        };
        quiet-battery = {
          fanSpeedUpdateFrequency = 5;
          movingAverageInterval = 30;
          speedCurve = [
            { temp = 0; speed = 0; }
            { temp = 60; speed = 0; }
            { temp = 68; speed = 15; }
            { temp = 76; speed = 30; }
            { temp = 84; speed = 55; }
            { temp = 92; speed = 100; }
          ];
        };
      };
    };
  };
}
