{ pkgs, lib, config, ... }:

let
  suspendScript = pkgs.writeShellScript "suspend-script" ''
    # check if any player has status "Playing"
    ${lib.getExe pkgs.playerctl} -a status | ${lib.getExe pkgs.ripgrep} Playing -q
    # only suspend if nothing is playing
    if [ $? == 1 ]; then
      ${pkgs.systemd}/bin/systemctl suspend
    fi
  '';

  brightnessctl = lib.getExe pkgs.brightnessctl;

  # timeout after which DPMS kicks in
  timeout = 300;
in
{
  # screen idle
  services.hypridle = {
    enable = true;
    settings = {

      general = {
        lock_cmd = lib.getExe config.programs.hyprlock.package;
        before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
      };

      listener = [
        {
          timeout = timeout - 10;
          on-timeout = "${brightnessctl} -s set 0";
          on-resume = "${brightnessctl} -r";
        }
        {
          inherit timeout;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = timeout + 10;
          on-timeout = suspendScript.outPath;
        }
      ];
    };
  };
}
