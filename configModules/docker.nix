{ config, pkgs, ... }:

{
  # Docker
  virtualisation.docker = {
    enable = false;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
  environment.systemPackages = with pkgs; [ docker-compose ];
}
