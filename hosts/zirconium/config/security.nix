{ pkgs, ... }: 

{  
  # Keyrings
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  programs.seahorse.enable = true; # Keyring manager
  
  # Antivirus
  services.clamav = {
    daemon.enable = true;
    fangfrisch.enable = true;
    fangfrisch.interval = "daily";
    updater.enable = true;
    updater.interval = "daily"; #man systemd.time
    updater.frequency = 12;
    scanner = {
      enable = true;
      interval = "Mon *-*-* 12:00:00";
    };
  };

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

  environment.systemPackages = with pkgs; [
    # Polkit
    libsecret  
    lxqt.lxqt-policykit 
    vulnix       #scan command: vulnix --system
    clamav       #scan command: sudo freshclam; clamscan [options] [file/directory/-]
    chkrootkit   #scan command: sudo chkrootkit
  ];   
}
