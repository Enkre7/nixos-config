{ config, lib, ... }:

let
  pubKeys = lib.filesystem.listFilesRecursive ../keys;
in
{
  users.mutableUsers = true;
  users.users.${config.user} = {
    isNormalUser = true;
    description = config.user;
    extraGroups = [ "networkmanager" "audio" "video" "wheel" ];
    hashedPassword = "$y$j9T$MRfXTPEQAKtLXnT/pPbV00$c9aKUJ6lvABT8bmH3jb9V3JaDZUJqXfZgkaZavGTPgC";
    openssh.authorizedKeys.keys = lib.lists.forEach pubKeys (key: builtins.readFile key);
  };
  users.users.root = {
    hashedPassword = "$y$j9T$MRfXTPEQAKtLXnT/pPbV00$c9aKUJ6lvABT8bmH3jb9V3JaDZUJqXfZgkaZavGTPgC";
    openssh.authorizedKeys.keys = config.users.users.${config.user}.openssh.authorizedKeys.keys;
  };
}
