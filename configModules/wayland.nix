{ pkgs, ... }:

{
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
    MOZ_ENABLE_WAYLAND = "1";
    XDG_SESSION_TYPE = "wayland";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "0";
    SDL_VIDEODRIVER = "wayland,x11";
    CLUTTER_BACKEND = "wayland";
    GDK_BACKEND = "wayland,x11";
    GSK_RENDERER = "vulkan";
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  environment.systemPackages = with pkgs; [
    wev
    wl-clipboard
    wayland-utils
  ];
}
