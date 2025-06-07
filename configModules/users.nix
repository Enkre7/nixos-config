{ config, lib, ... }:

{
  users.mutableUsers = true;
  users.users.${config.user} = {
    isNormalUser = true;
    description = config.user;
    extraGroups = [ "networkmanager" "audio" "video" "wheel" "input" "camera" "dialout" ];
    hashedPassword = "$y$j9T$MRfXTPEQAKtLXnT/pPbV00$c9aKUJ6lvABT8bmH3jb9V3JaDZUJqXfZgkaZavGTPgC";
    openssh.authorizedKeys.keyFiles = lib.filter (path: lib.hasSuffix ".pub" path) (lib.filesystem.listFilesRecursive ../keys);
  };
  users.users.root = {
    hashedPassword = "$y$j9T$MRfXTPEQAKtLXnT/pPbV00$c9aKUJ6lvABT8bmH3jb9V3JaDZUJqXfZgkaZavGTPgC";
    openssh.authorizedKeys.keyFiles = config.users.users.${config.user}.openssh.authorizedKeys.keyFiles;
  };
}
