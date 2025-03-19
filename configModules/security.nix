{ pkgs, ... }: 

{  
  # Keyrings
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  programs.seahorse.enable = true; # Keyring manager

  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    # Polkit
    libsecret  
    lxqt.lxqt-policykit 
    vulnix       #scan command: vulnix --system
    chkrootkit   #scan command: sudo chkrootkit
  ];   
}
