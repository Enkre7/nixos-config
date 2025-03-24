{ config, pkgs, lib, ... }:

{
  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };
  
  services.gnome-keyring.enable = true;
}
