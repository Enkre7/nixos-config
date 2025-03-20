{ config, inputs, ... }:

{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops.defaultSopsFile = ./secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.generateKey = false;
  sops.age.keyFile = "/home/${config.user}/.config/sops/age/keys.txt";

  environment.variables = {
    SOPS_AGE_KEY_FILE = config.sops.age.keyFile;
  };

  systemd.services.pcscd = {
    wantedBy = [ "multi-user.target" ];
    before = [ "sops-nix.service" ];
  };
}
