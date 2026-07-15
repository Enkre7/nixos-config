{ config, pkgs, lib, ... }:

let
  protonCalendarUrl = config.protonCalendarUrl;
  protonCalendarUrlParts = lib.splitString "?" protonCalendarUrl;
  protonCalendarFullPath = builtins.head protonCalendarUrlParts;
  protonCalendarQuery = builtins.elemAt protonCalendarUrlParts 1;
  protonCalendarResourcePath = lib.removePrefix "https://calendar.proton.me" protonCalendarFullPath;
in
{
  services.gnome.evolution-data-server.enable = true;

  services.radicale = {
    enable = true;
    user = config.user;
    group = "users";
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

  home-manager.users.${config.user} = { pkgs, ... }: {
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
      url = "${protonCalendarUrl}"

      [storage proton_local]
      type = "filesystem"
      path = "/var/lib/radicale/collections/collection-root/${config.user}/proton/"
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

    home.file.".config/evolution/sources/proton-webcal.source".text = ''
      [Data Source]
      DisplayName=Proton
      Enabled=true
      Parent=webcal-stub

      [Authentication]
      Host=calendar.proton.me
      Method=plain/password
      Port=443
      ProxyUid=system-proxy
      RememberPassword=true
      User=
      CredentialName=
      IsExternal=false

      [Security]
      Method=tls

      [WebDAV Backend]
      AvoidIfmatch=false
      CalendarAutoSchedule=false
      Color=
      DisplayName=
      EmailAddress=
      ResourcePath=${protonCalendarResourcePath}
      ResourceQuery=${protonCalendarQuery}
      SslTrust=
      Order=4294967295
      Timeout=30
      LimitDownloadDays=0

      [Calendar]
      BackendName=webcal
      Color=#62a0ea
      Selected=true
      Order=0

      [Offline]
      StaySynchronized=true

      [Refresh]
      Enabled=true
      EnabledOnMeteredNetwork=true
      IntervalMinutes=30
    '';
  };
}

