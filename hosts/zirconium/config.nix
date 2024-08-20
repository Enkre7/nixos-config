{ config, pkgs, lib, inputs, ... }: 

{
  imports = [
    inputs.home-manager.nixosModules.default
    ./variables.nix
    ../../configModules/nixos.nix
    ../../configModules/hardware.nix
    ../../configModules/battery.nix
    ../../configModules/lanzaboot.nix
    ../../configModules/networking.nix
    ../../configModules/tailscale.nix
    ../../configModules/mullvad-vpn.nix
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
  
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users.${config.user} = import ./home.nix;
  };  
  
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
<<<<<<< HEAD
  #networking.interfaces.enp4s0.wakeOnLan.enable = true;
  
  # Tools & libs
  environment.systemPackages = with pkgs; [
    tree
    wget
    curl
    iperf
    nmap
    netcat
    ffmpeg-full
    wev #wayland event viewer
    dmidecode
    dirbuster
    dirstalk
  ];
=======
  networking.interfaces.enp4s0.wakeOnLan.enable = true;
>>>>>>> 96a0c1ce76f7e7eea345b0d9c3ee994f012e62c8
}
