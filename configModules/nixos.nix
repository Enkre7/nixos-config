{ config, pkgs, lib, inputs, ... }: 

{
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
  
  # Disable nix inbuild documentation 
  documentation.doc.enable = false;

  # Nix helper module
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 5d --keep 3";
    flake = config.flakePath; # Flake location
  };
}
