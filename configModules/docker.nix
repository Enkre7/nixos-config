{ config, pkgs, ... }:

{
  # Docker
  virtualisation.docker = {
    enable = true;
    enableNvidia = true;
  };
  users.extraGroups.docker.members = [ config.user ];
  environment.systemPackages = with pkgs; [ docker-compose ];
}
