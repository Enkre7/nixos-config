{ pkgs, ... }:

{
  programs.btop = {
    enable = true;
    settings = {
      theme_background = false;
    };
  };

  programs.kitty = {
    enable = true;
    settings = {
      copy_on_select = true;
      clipboard_control = "write-clipboard read-clipboard write-primary read-primary";
      confirm_os_window_close = 0;
    };
  };

  # Terminal widgets
  home.packages = with pkgs; [
    cmatrix
    pipes-rs
    rsclock
    figlet
  ];

  # Terminal used by Thunar "Open terminal here"
  xdg.configFile."xfce4/helpers.rc".text = ''
    TerminalEmulator=kitty
  '';
  xdg.dataFile."xfce4/helpers/kitty.desktop".text = ''
    [Desktop Entry]
    NoDisplay=true
    Version=1.0
    Encoding=UTF-8
    Type=X-XFCE-Helper
    X-XFCE-Category=TerminalEmulator
    X-XFCE-Commands=kitty
    X-XFCE-CommandsWithParameter=kitty "%s"
    Icon=kitty
    Name=kitty
  '';
}
