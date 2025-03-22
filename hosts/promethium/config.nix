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
    #../../configModules/sops.nix
    ../../configModules/yubikey.nix
    ../../configModules/fingerprint.nix
    #../../configModules/clamav.nix
  # File system
    #../../configModules/impermanence.nix
  # Networking
    ../../configModules/networking.nix
    ../../configModules/tailscale.nix
    ../../configModules/mullvad-vpn.nix
  # Hardware management
    ../../configModules/battery.nix
    ../../configModules/sound.nix
    ../../configModules/graphics.nix
    ../../configModules/printing.nix
  # Virtualization
    ../../configModules/virtualisation.nix
  # User environment
    ../../configModules/locale.nix
    ../../configModules/shell.nix
    ../../configModules/terminal.nix
    ../../configModules/greetd.nix
    ../../configModules/hyprland.nix
    ../../configModules/stylix.nix
    ../../configModules/thunar.nix
  # Applications & services
    ../../configModules/games.nix
    #../../configModules/adb.nix
    #../../configModules/esp.nix
];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users.${config.user} = import ./home.nix;
    backupFileExtension = "backup";
  };

  # Debug
  #stylix.enable = lib.mkForce true;
  #stylix.autoEnable = lib.mkForce false;

  # Host specific settings  
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "thunderbolt"
    "usb_storage"
    "sd_mod"
  ];

  environment.sessionVariables = {
    STEAM_FORCE_DESKTOPUI_SCALING = "1.6";
  };
}

