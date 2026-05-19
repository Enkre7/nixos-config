{ config, pkgs, ... }:

let
  hyprlock = "${pkgs.hyprlock}/bin/hyprlock";
  hyprctl  = "hyprctl";
  pgrep    = "${pkgs.procps}/bin/pgrep";
  pkill    = "${pkgs.procps}/bin/pkill";

  lockNow = "${pgrep} -x hyprlock || ${hyprlock}";

  beforeSleep = pkgs.writeShellScript "lock-before-sleep" ''
    ${pgrep} -x hyprlock || ${hyprlock} &
    ${hyprctl} dispatch dpms off
  '';

  afterResume = pkgs.writeShellScript "lock-after-resume" ''
    ${pkill} -x hyprlock || true
    sleep 0.3
    ${hyprlock} &
    for i in $(seq 1 50); do
      ${pgrep} -x hyprlock >/dev/null && break
      sleep 0.1
    done
    sleep 0.5
    ${hyprctl} dispatch dpms on
  '';
in
{
  services.swayidle = {
    enable = true;
    package = pkgs.swayidle;
    systemdTargets = [ "hyprland-session.target" ];
    extraArgs = [ "-w" ];

    events = {
      before-sleep = "${beforeSleep}";
      after-resume = "${afterResume}";
      lock         = lockNow;
      unlock       = "${hyprctl} dispatch dpms on";
    };

    timeouts = [
      {
        timeout = 300;
        command = lockNow;
      }
      {
        timeout       = 330;
        command       = "${hyprctl} dispatch dpms off";
        resumeCommand = "${hyprctl} dispatch dpms on";
      }
    ];
  };
}
