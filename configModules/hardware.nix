{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];
  
  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.editor = false;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest; #pkgs.linuxPackages_zen
    kernelParams = [ ];
    extraModulePackages = [];
    consoleLogLevel = 3;
  };
  # Bios upgrade
  services.fwupd.enable = true;

  # For Nvidia
  hardware.nvidia.open = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.latest;  

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
