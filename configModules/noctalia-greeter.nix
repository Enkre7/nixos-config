{ config, lib, ... }:

{
  services.displayManager.noctalia-greeter = {
    enable = true;
    passwordlessSyncUsers = [ config.user ];
    cursorTheme = {
      inherit (config.stylix.cursor) package name;
    };
    settings = {
      session.default = "Hyprland (UWSM)";
      user.default = config.user;
      keyboard.layout = "fr";
      auth = {
        allow_empty_password = true;
        request_timeout = 0;
      };
      appearance.wallpaper = {
        blur = 0.5;
        tint = 0.3;
      };
    };
  };

  security.pam.services.greetd.rules.auth = lib.mkIf config.security.pam.services.greetd.fprintAuth {
    fprintd = {
      order = 10000;
      settings = {
        timeout = 10;
        max-tries = 2;
      };
    };
  };
}
