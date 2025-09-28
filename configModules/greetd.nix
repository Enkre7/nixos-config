{ pkgs, inputs, lib, ... }:

let
  tuigreet = "${pkgs.tuigreet}/bin/tuigreet";
  sessionsPaths = lib.concatStringsSep ":" [
    "${inputs.hyprland.packages.${pkgs.system}.hyprland}/share/wayland-sessions"
    "${pkgs.sway}/share/wayland-sessions"
    "/run/current-system/sw/share/wayland-sessions"
  ];
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

  # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}
