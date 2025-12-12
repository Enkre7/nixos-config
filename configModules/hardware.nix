{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  
  boot = {
    loader = {
      systemd-boot.enable = lib.mkDefault true;
      systemd-boot.editor = false;
      systemd-boot.configurationLimit = 20;
      efi.canTouchEfiVariables = true;
    };
    
    # Filesystems
    initrd.supportedFilesystems = [ "btrfs" ];
    supportedFilesystems = [ "btrfs" ];
    initrd.services.lvm.enable = true;
    
    kernelPackages = config.kernelPackage;
    kernelParams = [ ];
    extraModulePackages = [ ];
    consoleLogLevel = 3;
    tmp.cleanOnBoot = true;
  };
  
  # Bios upgrade
  services.fwupd.enable = true;
 
  # Nvidia GPU
  hardware.enableRedistributableFirmware = true;
  hardware.nvidia.open = false;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.latest;  
  hardware.nvidia.powerManagement.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
