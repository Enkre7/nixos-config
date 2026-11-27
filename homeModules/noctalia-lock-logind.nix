{ config, pkgs, ... }:

# noctalia locks before suspend and on idle, but ignores logind's
# session "Lock" signal (lid closed with HandleLidSwitch=lock,
# loginctl lock-session). swayidle only relays that signal here.
{
  services.swayidle = {
    enable = true;
    package = pkgs.swayidle;
    systemdTargets = [ "graphical-session.target" ];
    events = {
      lock = "${config.programs.noctalia.package}/bin/noctalia msg session lock";
    };
    timeouts = [ ];
  };
}
