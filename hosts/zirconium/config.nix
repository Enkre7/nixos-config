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
    #../../configModules/lanzaboote.nix
    ../../configModules/security.nix
    ../../configModules/polkit-gnome-agent.nix
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
    ../../configModules/coolercontrol.nix
    ../../configModules/coolerdash.nix
  # Virtualization
    ../../configModules/virtualisation.nix
    ../../configModules/docker.nix
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
    ../../configModules/file-manager.nix
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

  # Local AI (~/ia-locale): GPU access from rootless Docker containers through CDI
  # (docker run --device nvidia.com/gpu=all)
  hardware.nvidia-container-toolkit.enable = true;

  # Remote access (from promethium or the phone)
  # - power-on: Wake-on-LAN magic packet on the 10 GbE card (BIOS: ErP off, "Resume by PCI-E device" on)
  # - Claude Code: session started at boot in tmux « claude » with Remote Control
  #   (claude.ai/code or the Claude app), or over SSH: ssh zirconium -t tmux attach -t claude
  networking.interfaces.enp4s0.wakeOnLan.enable = true;
  environment.systemPackages = [ pkgs.tmux ];
  users.users.${config.user}.linger = true;
  systemd.user.services.claude-remote = {
    description = "Claude Code with Remote Control (tmux session « claude »)";
    wantedBy = [ "default.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    unitConfig.ConditionUser = config.user;
    serviceConfig = {
      Type = "forking";
      ExecStart = "${pkgs.tmux}/bin/tmux new-session -d -s claude -c %h \"/run/current-system/sw/bin/zsh -lc 'claude --remote-control zirconium; exec zsh -l'\"";
      ExecStop = "${pkgs.tmux}/bin/tmux kill-session -t claude";
      RemainAfterExit = true;
    };
  };

  environment.sessionVariables = {
    LC_ALL = "fr_FR.UTF-8";
    LANG = "fr_FR.UTF-8";
  };
}
