{ config, lib, pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    controlMaster = "auto"; # ssh session persist
    controlPath = "~/.ssh/sockets/S.%r@%h:%p";
    controlPersist = "10m";
    addKeysToAgent = "yes";
  };
  
  home.file = {
    # SSH sockets dir
    ".ssh/sockets/.keep".text = "# Managed by Home Manager"; 
    # Yubikey .pub symlink
    ".ssh/id_titanium.pub".source = config.lib.file.mkOutOfStoreSymlink "${config.flakePath}/keys/id_titanium.pub";
  };
}
