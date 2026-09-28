{ config, inputs, ... }:

{
  imports = [ inputs.impermanence.nixosModules.home-manager.impermanence ]; 
  
  home.persistence."/persist/home" = {
    directories = [
      "Downloads"
      "Téléchargements"
      "Nextcloud"
      "Music"
      "Pictures"
      "Images"
      "Documents"
      "Videos"
      "Mount"
      ".gnupg"
      ".ssh"
      ".nixops"
      ".local"
      ".config"
      ".mozilla" # To modify
      {
        directory = ".local/share/Steam";
        method = "symlink";
      }
    ];
    files = [
      ".screenrc"
      ".mozilla/firefox/${config.user}/formhistory.sqlite" # Autocomplete history
      ".mozilla/firefox/${config.user}/cookies.sqlite" # Cookies
      ".mozilla/firefox/${config.user}/webappsstore.sqlite" # DOM storage
      ".mozilla/firefox/${config.user}/chromeappsstore.sqlite" # DOM storage
    ];
    allowOther = true;
  };
}
