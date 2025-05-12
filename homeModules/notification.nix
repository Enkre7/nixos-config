{ pkgs, ... }:

{
  services.mako = {
    enable = true;
    settings = {
      border-radius = 10;
      default-timeout = 1000;
    };
  };
  home.packages = with pkgs; [ libnotify ];
}
