{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    nextcloud-client
  ];
  
  home.file."Nextcloud/.keep".text = "";
  
  home.activation.nextcloudConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p "${config.home.homeDirectory}/.config/Nextcloud"
    
    if [ ! -f "${config.home.homeDirectory}/.config/Nextcloud/nextcloud.cfg" ]; then
      echo "[General]
crashReporter=true
monoIcons=false
newBigFolderSizeLimit=500
optionalServerNotifications=true
showInExplorerNavigationPane=true
useNewBigFolderSizeLimit=true
keyChainUsePassword=true" > "${config.home.homeDirectory}/.config/Nextcloud/nextcloud.cfg"
    fi
    
    chmod -R 755 "${config.home.homeDirectory}/.config/Nextcloud"
    chmod 600 "${config.home.homeDirectory}/.config/Nextcloud/nextcloud.cfg"
    
    chown -R ${config.user}:users "${config.home.homeDirectory}/.config/Nextcloud"
  '';
}
