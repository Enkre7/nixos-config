{ pkgs, ... }:

{
  services.printing = {
    enable = true;
    drivers = with pkgs; [ brgenml1cupswrapper ];
  };
  programs.system-config-printer.enable = true;
  hardware.sane.enable = true; # scanner
}
