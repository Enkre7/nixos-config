{ pkgs, ... }:

let
  lock = pkgs.writeShellScript "lock-guard" ''
    pgrep -x hyprlock >/dev/null 2>&1 || exec ${pkgs.hyprlock}/bin/hyprlock
  '';
in
{
  services.swayidle = {
    enable = true;
    package = pkgs.swayidle;
    systemdTargets = [ "graphical-session.target" ];

    events = {
      before-sleep = "${lock}";
      lock = "${lock}";
    };

    timeouts = [
      {
        timeout = 600;
        command = "${lock}";
      }
    ];

    extraArgs = [ "-w" ];
  };
}
