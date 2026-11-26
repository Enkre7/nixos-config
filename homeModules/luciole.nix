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

  systemd.user.services.trash-autoclean = {
    Unit.Description = "Remove items trashed more than 30 days ago";
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.trash-cli}/bin/trash-empty -f 30";
    };
  };
  systemd.user.timers.trash-autoclean = {
    Timer = {
      OnCalendar = "daily";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };

  xdg.dataFile."luciole/scripts/Print" = {
    executable = true;
    text = ''
      #!/bin/sh
      ${pkgs.cups}/bin/lp -- "$@" && ${pkgs.libnotify}/bin/notify-send "Print" "$# document(s) sent to the printer"
    '';
  };
}
