{ config, ... }:

{
  users = {
    mutableUsers = true;
    users = {
      ${config.user} = {
        isNormalUser = true;
        description = config.user;
        extraGroups = [ "networkmanager" "wheel" ];
        #hashedPassword = "";
      };
      #root.hashedPassword = "";
    };
  };
}
