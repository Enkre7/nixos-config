{ pkgs, lib, config, ... }:

{
  programs.niri.enable = true;
  environment.systemPackages = with pkgs; [ niri ];

  xdg.portal.config = {
    niri.default = [ "gnome" "gtk" ];
  };

  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_DESKTOP = "niri";
  };  
}
