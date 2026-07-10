{ config, pkgs, ... }:

{
  # Radicale : sert de pont CalDAV local pour le calendrier Proton
  services.radicale = {
    enable = true;
    settings = {
      server.hosts = [ "127.0.0.1:5232" ];
      auth = {
        type = "htpasswd";
        htpasswd_filename = "/var/lib/radicale/htpasswd";
        htpasswd_encryption = "bcrypt";
      };
      storage.filesystem_folder = "/var/lib/radicale/collections";
    };
  };

  systemd.services.radicale.serviceConfig = {
    StateDirectory = "radicale";
    StateDirectoryMode = "0750";
  };

  # vdirsyncer : recupere le flux ICS Proton et le pousse dans radicale
  home-manager.users.enkre = { pkgs, ... }: {
    home.packages = [ pkgs.vdirsyncer ];

    xdg.configFile."vdirsyncer/config".text = ''
      [general]
      status_path = "~/.local/share/vdirsyncer/status/"

      [pair proton_calendar]
      a = "proton_remote"
      b = "proton_local"
      collections = null

      [storage proton_remote]
      type = "http"
      url = "https://calendar.proton.me/api/calendar/v1/url/tw9unwlYgWjJrPhfWEDLiHkT8B0XP2MSJEY1jx9Pk18BlLgUI1n2oIWrSWOGC1-Em2nrTeo4qicLSpZu_zN87A==/calendar.ics?CacheKey=CInFC25Kbi7pfheWUP78KA%3D%3D&PassphraseKey=vNYxf0PgsLlzISbS4LkFsntI6f94AEPL9VUbUT3V8cw%3D"

      [storage proton_local]
      type = "filesystem"
      path = "/var/lib/radicale/collections/collection-root/enkre/proton/"
      fileext = ".ics"
    '';

    systemd.user.services.vdirsyncer-proton = {
      Unit.Description = "Sync Proton calendar via vdirsyncer";
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.vdirsyncer}/bin/vdirsyncer sync proton_calendar";
      };
    };

    systemd.user.timers.vdirsyncer-proton = {
      Unit.Description = "Run vdirsyncer for Proton calendar periodically";
      Timer = {
        OnBootSec = "1m";
        OnUnitActiveSec = "10m";
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };
}
