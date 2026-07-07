{ inputs, ... }:

{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia = {
    enable = true;
    systemd.enable = true;

    settings = {
      bar = {
        position = "top";
        barType = "simple";
        density = "comfortable";

        widgets.left = [
          { type = "Clock"; }
          { type = "ActiveWindow"; }
        ];

        widgets.center = [
          { type = "Workspace"; settings.showOccupiedOnly = true; }
        ];

        widgets.right = [
          { type = "Tray"; }
          { type = "Network"; settings.showMode = "onhover"; }
          { type = "Bluetooth"; settings.showMode = "onhover"; }
          { type = "Battery"; }
          { type = "Volume"; }
          { type = "NotificationHistory"; }
        ];
      };
    };
  };
}
