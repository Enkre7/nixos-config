{ pkgs, ... }: 

{  
  # Keyrings
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  programs.seahorse.enable = true; # Keyring manager
  
  # Enable USB Guard
  services.usbguard = {
    enable = false;
    dbus.enable = true;
    implicitPolicyTarget = "block";
    # FIXME: set yours pref USB devices (change {id} to your trusted USB device), use `lsusb` command (from usbutils package) to get list of all connected USB devices including integrated devices like camera, bluetooth, wifi, etc. with their IDs or just disable `usbguard`
    rules = ''
      allow id {id} # device 1
      allow id {id} # device 2
    '';
  };

  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    # Polkit
    libsecret  
    lxqt.lxqt-policykit 
    vulnix       #scan command: vulnix --system
    chkrootkit   #scan command: sudo chkrootkit
  ];   
}
