{ ... }:

{
  hardware.fw-fanctrl = {
    enable = true;
    config = {
      defaultStrategy = "quiet-performance";
      strategyOnDischarging = "quiet-battery";
      strategies = {
        silent = {
          fanSpeedUpdateFrequency = 5;
          movingAverageInterval = 40;
          speedCurve = [
            { temp = 0; speed = 0; }
            { temp = 62; speed = 0; }
            { temp = 70; speed = 15; }
            { temp = 78; speed = 30; }
            { temp = 86; speed = 55; }
            { temp = 94; speed = 100; }
          ];
        };
        performance = {
          fanSpeedUpdateFrequency = 3;
          movingAverageInterval = 10;
          speedCurve = [
            { temp = 0; speed = 15; }
            { temp = 45; speed = 20; }
            { temp = 55; speed = 35; }
            { temp = 65; speed = 55; }
            { temp = 75; speed = 80; }
            { temp = 82; speed = 100; }
          ];
        };
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
