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
    kernelPackages = config.kernelPackage;
    kernelParams = [];
    extraModulePackages = [];
    consoleLogLevel = 3;
    tmp.cleanOnBoot = true;
  };
  # Bios upgrade
  services.fwupd.enable = true;

  # For Nvidia
  hardware.nvidia.open = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.latest;  
  hardware.nvidia.powerManagement.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
