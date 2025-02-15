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
}
