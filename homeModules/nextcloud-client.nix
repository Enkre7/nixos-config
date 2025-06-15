{ pkgs, lib, ... }:

{
  services.nextcloud-client = {
    enable = true;
    package = pkgs.nextcloud-client;
    startInBackground = true;
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
