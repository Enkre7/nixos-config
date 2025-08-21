{ pkgs, config, osConfig, ... }:

{
  programs.lutris = {
    enable = true;
    package = pkgs.lutris;
    steamPackage = osConfig.programs.steam.package;
    extraPackages = with pkgs; [
      winetricks
      vulkan-tools
      vulkan-loader
    ];
    wine = with pkgs; [
      wineWowPackages.waylandFull
      wineWowPackages.stable
    ];
    runners = {
      wine = {
        settings = {
          runner.runner_executable = "${pkgs.wineWowPackages.waylandFull}/bin/wine";
          system.dxvk = true;
        };
      };
      steam = {
        settings = {
          runner.runner_executable = "${osConfig.programs.steam.package}/bin/steam";
        };
      };
    };
  };

  xdg.mimeApps.defaultApplications = {
    "application/x-wine-extension-msi" = "net.lutris.Lutris.desktop";
    "application/x-ms-dos-executable" = "net.lutris.Lutris.desktop";
    "application/x-lutris-installer" = "net.lutris.Lutris.desktop";
    "x-scheme-handler/lutris" = "net.lutris.Lutris.desktop";
  };

  home.sessionVariables = {
    WINEPREFIX = "$HOME/.wine";
    WINEARCH = "win64";
  };
}
