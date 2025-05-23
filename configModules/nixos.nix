{ config, pkgs, inputs, ... }: 

{
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    settings.auto-optimise-store = true;
    settings.substituters = [
      "https://nix-community.cachix.org"
      "https://cache.nixos.org/"
    ];
    settings.trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    optimise.automatic = true;
  };
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = config.stateVersion;
    
  # Disable nix inbuild documentation 
  documentation.doc.enable = false;

  # Nix helper module
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = config.flakePath; # Flake location
  };

  # Nixd (Nix language server)
  environment.systemPackages = with pkgs; [
    nixd
    nixfmt-rfc-style
  ];
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
}
