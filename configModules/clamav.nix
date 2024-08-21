{ pkgs, ... }:

{
  # Antivirus
  services.clamav = { 
    daemon.enable = true;
    fangfrisch.enable = true;
    fangfrisch.interval = "daily";
    updater.enable = true;
    updater.interval = "daily"; #man systemd.time
    updater.frequency = 12;
    scanner = {
      enable = true;
      interval = "Mon *-*-* 12:00:00";
    };
  };

  # Scan command: sudo freshclam; clamscan [options] [file/directory/-]
  environment.systemPackages = with pkgs; [ clamav ];
}
