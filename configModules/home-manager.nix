{ config, inputs, ... }:

{
  imports = [ inputs.home-manager.nixosModules.default ];
  
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users.${config.user} = import ../homeModules/home-manager.nix;
  };
}
