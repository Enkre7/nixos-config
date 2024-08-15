{ config, pkgs, lib, inputs, ... }: 

{
  imports = [
    ../variables.nix
    ./hardware.nix
    ./battery.nix
    ./lanzaboot.nix
    ./networking.nix
    #./impermanence.nix
    ./virtualisation.nix
    ./locale.nix
    ./sound.nix
    ./graphics.nix
    ./hyprland.nix
    ./home-manager.nix
    ./users.nix
    ./shell.nix
    ./terminal.nix
    ./greetd.nix
    ./style.nix
    ./security.nix
    ./fingerprint.nix
    ./yubikey.nix
    ./file-manager.nix
    ./printing.nix
    ./games.nix
  ];
  
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    settings.auto-optimise-store = true;
    optimise.automatic = true;
    /*gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };*/
  };
  nixpkgs.config.allowUnfree = true;
  documentation.doc.enable = false;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 5d --keep 3";
    flake = config.flakePath; # Flake location
  };

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

