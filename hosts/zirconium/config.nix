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
    ../../configModules/yubikey.nix
    ../../configModules/file-manager.nix
    ../../configModules/printing.nix
    ../../configModules/games.nix
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users.${config.user} = import ./home.nix;
  };
  
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "thunderbolt"
    "usb_storage"
    "sd_mod"  
  ];

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

  system.stateVersion = "24.05";
}

