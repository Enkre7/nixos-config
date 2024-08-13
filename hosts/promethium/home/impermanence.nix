{ pkgs, inputs, ... }:

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
      ".mozilla/firefox/enkre/formhistory.sqlite" # Autocomplete history
      ".mozilla/firefox/enkre/cookies.sqlite" # Cookies
      ".mozilla/firefox/enkre/webappsstore.sqlite" # DOM storage
      ".mozilla/firefox/enkre/chromeappsstore.sqlite" # DOM storage
    ];
    allowOther = true;
  };
}
