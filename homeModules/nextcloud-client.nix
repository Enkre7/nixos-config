{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    nextcloud-client
  ];
  
  home.file.".config/Nextcloud/nextcloud.cfg".text = lib.mkAfter ''
    [General]
    useUploadLimit=false
    newBigFolderSizeLimit=500
    optionalServerNotifications=true
    showInExplorerNavigationPane=true
    
    [Accounts]
    0\Folders\1\ignoreHiddenFiles=false
    0\Folders\1\localPath=${config.home.homeDirectory}/Nextcloud
    0\Folders\1\paused=false
    0\Folders\1\targetPath=/
    0\Folders\1\usePlaceholders=false
    0\Folders\1\version=2
    0\authType=webflow
    0\databaseDirectoryPermissions=0700
    0\serverVersion=
    0\url=https://spacecloud.7mairot.com
    
    0\http_credentials_encrypted=true
    
    [Settings]
    geometry=@ByteArray()
  '';
}
