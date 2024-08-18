{ config, pkgs, lib, inputs, ... }: 

{
  imports = [
    ./variables.nix
    ../../configModules/nixos.nix
    ../../configModules/home-manager.nix
    ../../configModules/hardware.nix
    ../../configModules/battery.nix
    ../../configModules/lanzaboot.nix
    ../../configModules/networking.nix
    #../../configModules/impermanence.nix
    ../../configModules/virtualisation.nix
    ../../configModules/locale.nix
    ../../configModules/sound.nix
    ../../configModules/graphics.nix
    ../../configModules/hyprland.nix
    ../../configModules/users.nix
    ../../configModules/shell.nix
    ../../configModules/terminal.nix
    ../../configModules/greetd.nix
    ../../configModules/style.nix
    ../../configModules/security.nix
    ../../configModules/fingerprint.nix
    ../../configModules/rgb.nix
    ../../configModules/yubikey.nix
    ../../configModules/thunar.nix
    ../../configModules/printing.nix
    ../../configModules/games.nix
    ../../configModules/adb.nix
  ];
  
  # Host specific settings
    
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usb_storage"
    "usbhid"
    "sd_mod"  
  ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  networking.interfaces.enp4s0.wakeOnLan.enable = true;
}
