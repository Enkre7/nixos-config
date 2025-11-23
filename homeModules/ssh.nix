{ config, lib, pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [ "~/.ssh/config.d/*" ];
    matchBlocks = {
      "*" = {
        controlMaster = "auto";
        controlPath = "~/.ssh/sockets/S.%r@%h:%p";
        controlPersist = "10m";
        addKeysToAgent = "yes";
      };
    };
  };
  
  home.file = {
    ".ssh/sockets/.keep".text = "# Managed by Home Manager";
    ".ssh/config.d/.keep".text = "# SSH config includes";
    ".ssh/id_titanium.pub".source = config.lib.file.mkOutOfStoreSymlink "${config.flakePath}/keys/id_titanium.pub";
  };
}
