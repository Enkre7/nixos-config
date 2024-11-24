{ config, pkgs, ... }:

{
  # Docker
  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ config.user ];
  environment.systemPackages = with pkgs; [ docker-compose ];
  hardware.nvidia-container-toolkit.enable = true;
}
