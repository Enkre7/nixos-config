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
      ".mozilla" # To modify
      {
        directory = ".local/share/Steam";
        method = "symlink";
      }
    ];
    files = [
      ".screenrc"
    ];
    allowOther = true;
  };
}
