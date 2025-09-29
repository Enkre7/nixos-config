{ pkgs, lib, config, ... }:

{
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  xdg.portal.config = {
    sway.default = [ "wlr" "gtk" ];
  };

  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "sway";
    XDG_SESSION_DESKTOP = "sway";
  };  
}
