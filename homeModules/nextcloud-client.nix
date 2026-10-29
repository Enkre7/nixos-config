{ pkgs, lib, ... }:

{
  services.nextcloud-client = {
    enable = true;
    package = pkgs.nextcloud-client;
    startInBackground = true;
  };

  systemd.user.services.nextcloud-client = {
    Unit = {
      After = [ "noctalia.service" ];
      Wants = [ "noctalia.service" ];
    };
    Service.ExecStartPre = "${pkgs.writeShellScript "wait-tray" ''
      for _ in $(seq 1 60); do
        ${pkgs.systemd}/bin/busctl --user status org.kde.StatusNotifierWatcher >/dev/null 2>&1 && exit 0
        sleep 0.5
      done
    ''}";
  };

  # The systemd service starts the client, block its own UWSM autostart entry
  xdg.configFile."autostart/Nextcloud.desktop" = {
    force = true;
    text = ''
      [Desktop Entry]
      Type=Application
      Name=Nextcloud
      Hidden=true
    '';
  };

  home.packages = with pkgs; [
    nextcloud-client
  ];

  # Prevent nextcloud window to close when unfocused
  home.activation.nextcloudConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Create folder if not exist
    mkdir -p $HOME/.config/Nextcloud/
    
    # Create file if not exist
    if [ ! -f $HOME/.config/Nextcloud/nextcloud.cfg ]; then
      echo "[General]" > $HOME/.config/Nextcloud/nextcloud.cfg
    fi
    
    # Edit file
    if ! grep -q "showMainDialogAsNormalWindow" $HOME/.config/Nextcloud/nextcloud.cfg; then
      if grep -q "^\[General\]" $HOME/.config/Nextcloud/nextcloud.cfg; then
        sed -i '/^\[General\]/a showMainDialogAsNormalWindow=true' $HOME/.config/Nextcloud/nextcloud.cfg
      else
        echo -e "[General]\nshowMainDialogAsNormalWindow=true" >> $HOME/.config/Nextcloud/nextcloud.cfg
      fi
    fi
  '';
}
