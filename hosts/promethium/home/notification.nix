{ pkgs, ... }:

{
  services.mako = {
    enable = true;
    borderRadius = 10;
    defaultTimeout = 1000;
  };

  home.packages = with pkgs; [ libnotify ];
}
