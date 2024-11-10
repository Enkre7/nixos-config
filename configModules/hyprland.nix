{ pkgs, inputs, ... }:

{
  # Window manager
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };
  programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;
  
  # Wayland event viewer
  environment.systemPackages = with pkgs; [ wev ];
  
  # Resize & electron support
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };  
}
