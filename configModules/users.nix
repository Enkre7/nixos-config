{ config, lib, ... }:

{
  users.mutableUsers = true;
  users.users.${config.user} = {
    isNormalUser = true;
    description = config.user;
    extraGroups = [ "networkmanager" "audio" "video" "wheel" "input" "camera" "dialout" ];
    hashedPassword = config.hashedPassword;
    openssh.authorizedKeys.keyFiles = lib.filter (path: lib.hasSuffix ".pub" path) (lib.filesystem.listFilesRecursive ../keys);
    home = "/home/${config.user}";
  };
  systemd.tmpfiles.rules = [
    "d /home/${config.user} 0755 ${config.user} users -"
  ];

  users.users.root = {
    hashedPassword = config.hashedPassword;
    openssh.authorizedKeys.keyFiles = config.users.users.${config.user}.openssh.authorizedKeys.keyFiles;
  };
}
