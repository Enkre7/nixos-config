{ config, inputs, pkgs, ... }:

{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  environment.systemPackages = with pkgs; [ sops age ];

  sops.defaultSopsFile = ./secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.generateKey = false;

  systemd.services.sops-nix = {
    path = [ pkgs.age-plugin-yubikey ];
    environment = {
      SOPS_AGE_KEY_FILE = "";
    };
  };

  systemd.services.pcscd = {
    wantedBy = [ "multi-user.target" ];
    before = [ "sops-nix.service" ];
  };
}
