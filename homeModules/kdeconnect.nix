{ pkgs, ... }:

{
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  # Hide all .desktop, except for the main app and settings
  xdg.desktopEntries = {
    "org.kde.kdeconnect.sms" = {
      exec = "";
      name = "KDE Connect SMS";
      settings.NoDisplay = "true";
    };
    "org.kde.kdeconnect.nonplasma" = {
      exec = "";
      name = "KDE Connect Indicator";
      settings.NoDisplay = "true";
    };
  };

  systemd.user.services.kdeconnect-indicator = {
    Unit.After = [ "noctalia.service" ];
    Unit.Requires = [ "noctalia.service" ];
  };
}
