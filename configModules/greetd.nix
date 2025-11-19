{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:

let
  tuigreet = "${pkgs.tuigreet}/bin/tuigreet";

  sessionsPaths = lib.concatStringsSep ":" (
    lib.optional (config.programs.hyprland.enable or false)
      "${inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland}/share/wayland-sessions"
    ++ lib.optional (config.programs.sway.enable or false) "${pkgs.sway}/share/wayland-sessions"
    ++ lib.optional (config.programs.niri.enable or false) "${pkgs.niri}/share/wayland-sessions"
    ++ [ "/run/current-system/sw/share/wayland-sessions" ]
  );
in
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${tuigreet} --time --remember --remember-session --sessions ${sessionsPaths}";
        user = "greeter";
      };
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
