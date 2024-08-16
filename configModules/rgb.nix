{ config, pkgs, ... }:

{
  # Support for Razer peripherals and AIO
  hardware.openrazer.enable = true;
  environment.systemPackages = with pkgs; [ openrazer-daemon polychromatic liquidctl ];
  users.users.${config.user}.extraGroups = [ "openrazer" ];

  # RBB controller
  services.hardware.openrgb.enable = true;
}
