{ pkgs, ... }:

{
  programs.btop = {
    enable = false;
    settings = {
      color_theme = "TTY";
      theme_background = false;
    };
  };

  programs.kitty = {
    enable = true;
    settings = {
      copy_on_select = true;
      clipboard_control = "write-clipboard read-clipboard write-primary read-primary";
      confirm_os_window_close = -1;
    };
  };
}
