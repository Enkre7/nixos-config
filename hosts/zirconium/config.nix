{ config, pkgs, lib, inputs, ... }: 

{
  imports = [
  # Core
    inputs.home-manager.nixosModules.default
    ./variables.nix
    ../../configModules/nixos.nix
    ../../configModules/hardware.nix
    ../../configModules/users.nix
  # Boot & security
    ../../configModules/lanzaboot.nix
    ../../configModules/security.nix
    ../../configModules/sops.nix
    ../../configModules/yubikey.nix
    #../../configModules/impermanence.nix
  # Networking
    ../../configModules/networking.nix
    ../../configModules/tailscale.nix
    ../../configModules/mullvad-vpn.nix
  # Hardware management
    ../../configModules/battery.nix
    ../../configModules/audio.nix
    ../../configModules/graphics.nix
    ../../configModules/printing.nix
    ../../configModules/rgb.nix
  # Virtualization
    ../../configModules/virtualisation.nix
  # Desktop environment
    ../../configModules/locale.nix
    ../../configModules/shell.nix
    ../../configModules/terminal.nix
    ../../configModules/greetd.nix
    ../../configModules/wayland.nix    
    ../../configModules/hyprland.nix
    #../../configModules/sway.nix
    #../../configModules/niri.nix
    ../../configModules/stylix.nix
    ../../configModules/thunar.nix
  # Applications & services
    ../../configModules/chromium.nix
    ../../configModules/games.nix
    #../../configModules/adb.nix
];
  
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users.${config.user} = import ./home.nix;
    backupFileExtension = "backup-" + pkgs.lib.readFile "${pkgs.runCommand "timestamp" {} "echo -n `date '+%Y%m%d%H%M%S'` > $out"}";
  };  

  # Debug
  #stylix.enable = lib.mkForce false;
  #stylix.autoEnable = lib.mkForce false;
  
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

  environment.sessionVariables = {
    STEAM_FORCE_DESKTOPUI_SCALING = "1.3334";
  };
}
