{ pkgs, ... }:

{
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  # Hide all .desktop, except for org.kde.kdeconnect.settings
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
    "org.kde.kdeconnect.app" = {
      exec = "";
      name = "KDE Connect";
      settings.NoDisplay = "true";
    };
  };

  systemd.user.services.kdeconnect-indicator = {
    Unit.After = [ "noctalia.service" ];
    Unit.Requires = [ "noctalia.service" ];
  };
}
