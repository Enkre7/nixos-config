{ config, inputs, ... }:

{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops.defaultSopsFile = ./secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.generateKey = false;
}
