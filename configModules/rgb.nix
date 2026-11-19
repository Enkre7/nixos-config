{ config, pkgs, ... }:

{
  # Razer peripherals and AIO support
  hardware.openrazer = {
    enable = true;
    devicesOffOnScreensaver = false;
  };
  environment.systemPackages = with pkgs; [ openrazer-daemon i2c-tools ];
  users.users.${config.user}.extraGroups = [ "openrazer" ];

  # RGB controller
  boot = {
    kernelParams = [ "acpi_enforce_resources=lax" ];
    kernelModules = [ "i2c-dev" "i2c-piix4" ];
  };

  hardware.i2c.enable = true;
  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
    motherboard = "amd";
    server.port = 6743;
  };

  systemd.services.openrgb-color = {
    description = "Apply the default OpenRGB color";
    after = [ "openrgb.service" ];
    requires = [ "openrgb.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      User = config.user;
    };
    path = [ config.services.hardware.openrgb.package ];
    script = ''
      client="--client 127.0.0.1:${toString config.services.hardware.openrgb.server.port} --nodetect --noautoconnect"
      for _ in $(seq 1 30); do
        openrgb $client --list-devices 2>/dev/null | grep -q Razer && break
        sleep 1
      done
      openrgb $client --mode static --color 00FF00 --brightness 100
    '';
  };

  powerManagement.resumeCommands = "${config.systemd.package}/bin/systemctl restart --no-block openrgb-color.service";
}
