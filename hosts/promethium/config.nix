{ config, pkgs, lib, inputs, ... }: 

{
  imports = [
    inputs.home-manager.nixosModules.default
    ./variables.nix
    ../../configModules/nixos.nix
    ../../configModules/hardware.nix
    ../../configModules/battery.nix
    ../../configModules/lanzaboot.nix
    #../../configModules/sops.nix
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
    #../../configModules/clamav.nix
    ../../configModules/fingerprint.nix
    ../../configModules/yubikey.nix
    ../../configModules/thunar.nix
    ../../configModules/printing.nix
    ../../configModules/games.nix
    ../../configModules/adb.nix
    ../../configModules/esp.nix
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users.${config.user} = import ./home.nix;
  };

  # Debug
  #stylix.enable = lib.mkForce false;
  
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

