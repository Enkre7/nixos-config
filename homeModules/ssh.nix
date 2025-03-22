{ config, lib, pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    controlMaster = "auto"; # ssh session perssist
    controlPath = "~/.ssh/sockets/S.%r@%h:%p";
    controlPersist = "10m";
    extraConfig = ''
      AddKeysToAgent yes
    '';
  };
  
  home.file = {
    # SSH sockets dir
    ".ssh/sockets/.keep".text = "# Managed by Home Manager"; 
    # Yubikey .pub symlink
    ".ssh/id_titanium.pub".source = config.lib.file.mkOutOfStoreSymlink "${config.flakePath}/keys/id_titanium.pub";
  };
  
  # set perms
  home.activation.sshPermissions = config.lib.dag.entryAfter ["writeBoundary"] ''
    chmod 700 ~/.ssh
    chmod 644 ~/.ssh/*.pub
  '';
}
