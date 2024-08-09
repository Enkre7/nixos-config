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
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = [ "kvm-amd" ];
    kernelParams = [];
    initrd = {
      kernelModules = [ "amdgpu" ];
      availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod" ];
    };
    extraModulePackages = [];
    consoleLogLevel = 3;
  };
  services.fwupd.enable = true; #bios upgrade

  /*##########
  # To remove with disko implementation
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/de20b016-e630-4840-b250-b6a1fd5a4e06";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/D615-0F95";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };
  
  swapDevices = [];
  # compresses half the ram for use as swap
  zramSwap.enable = true;
  ##########*/

  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
