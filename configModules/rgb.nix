{ config, pkgs, ... }:

{
  # Razer peripherals and AIO support
  hardware.openrazer.enable = true;
  environment.systemPackages = with pkgs; [ openrazer-daemon polychromatic liquidctl gkraken ];
  users.users.${config.user}.extraGroups = [ "openrazer" ];
  hardware.gkraken.enable = true;

  # RBB controller
  services.hardware.openrgb.enable = true;
}
