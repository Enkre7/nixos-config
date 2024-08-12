{ config, ... }:

{
  users = {
    mutableUsers = true;
    users = {
      ${config.user} = {
        isNormalUser = true;
        description = config.user;
        extraGroups = [ "networkmanager" "wheel" ];
        hashedPassword = "$y$j9T$MRfXTPEQAKtLXnT/pPbV00$c9aKUJ6lvABT8bmH3jb9V3JaDZUJqXfZgkaZavGTPgC";
      };
      root.hashedPassword = "$y$j9T$MRfXTPEQAKtLXnT/pPbV00$c9aKUJ6lvABT8bmH3jb9V3JaDZUJqXfZgkaZavGTPgC";
    };
  };
}
