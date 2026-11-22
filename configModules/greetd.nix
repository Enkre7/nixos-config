{ pkgs, config, lib, ... }:
let
  hyprland = config.programs.hyprland.package;
  uwsm = config.programs.uwsm.package;
  hyprlandUwsmSession = pkgs.writeTextFile {
    name = "hyprland-uwsm";
    destination = "/share/wayland-sessions/hyprland-uwsm.desktop";
    text = ''
      [Desktop Entry]
      Name=Hyprland (UWSM)
      Comment=Hyprland compositor managed by UWSM
      Exec=${lib.getExe uwsm} start -F -D Hyprland -- ${hyprland}/bin/start-hyprland
      Type=Application
      DesktopNames=Hyprland
      Keywords=tiling;wayland;compositor;
    '';
  };
in
{
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --sessions ${hyprlandUwsmSession}/share/wayland-sessions";
      user = "greeter";
    };
  };

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}
