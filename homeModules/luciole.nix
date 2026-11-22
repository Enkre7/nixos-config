{ inputs, pkgs, ... }:

{
  imports = [ inputs.luciole.homeModules.default ];

  programs.luciole = {
    enable = true;
    settings = {
      schema_version = 1;
      browser = {
        view_mode = "list";
        expandable_folders = true;
        directories_first = true;
        terminal_command = "kitty";
      };
    };
  };

  xdg.dataFile."luciole/scripts/Print" = {
    executable = true;
    text = ''
      #!/bin/sh
      ${pkgs.cups}/bin/lp -- "$@" && ${pkgs.libnotify}/bin/notify-send "Print" "$# document(s) sent to the printer"
    '';
  };
}
