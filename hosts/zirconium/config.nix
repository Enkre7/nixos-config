{ config, pkgs, lib, inputs, ... }: 

{
  imports = [
    ../../global-variables.nix
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
    ../../configModules/home-manager.nix
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
